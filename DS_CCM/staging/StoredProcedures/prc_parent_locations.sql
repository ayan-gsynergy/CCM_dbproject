CREATE proc [staging].[prc_parent_locations](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id, location_id, is_active FROM [staging].[parent_locations] WHERE process_status = 'N';
	DECLARE @parent_id int, @location_id int, @is_active char (1);
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @parent_id, @location_id, @is_active;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF @is_active not in ('Y','N')
							RAISERROR('is_active column should only contain ''Y''/''N''',16,1)
						IF exists (select 1 from dbo.parent_locations where parent = @parent_id and location = @location_id)
							UPDATE [dbo].[parent_locations] SET is_active = case @is_active when 'N' then 0 else 1 end, _updated_by = @updated_by, _updated_by_action = @updated_by_action where parent = @parent_id and location = @location_id;
						ELSE
							INSERT INTO [dbo].[parent_locations] (id, parent, location, is_active, _updated_by, _updated_by_action) values (next value for parent_locations_seq, @parent_id, @location_id, case @is_active when 'N' then 0 else 1 end, @updated_by, @updated_by_action);						
						UPDATE staging.parent_locations set process_status = 'C' where parent_id = @parent_id and location_id = @location_id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk_customer_parent_locations_customer_parents%')
					UPDATE staging.parent_locations set process_status = 'E', error_message = 'Parent not found' where parent_id = @parent_id and location_id = @location_id;
				ELSE IF (ERROR_MESSAGE() like '%fk_customer_parent_locations_locations%')
					UPDATE staging.parent_locations set process_status = 'E', error_message = 'Location not found' where parent_id = @parent_id and location_id = @location_id;
				ELSE
					UPDATE staging.parent_locations set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where parent_id = @parent_id and location_id = @location_id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.parent_locations where process_status <> 'C')
END;
GO

