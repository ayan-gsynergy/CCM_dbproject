CREATE proc [staging].[prc_location_types](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, description, location_type_category, sort FROM [staging].[location_types] WHERE process_status = 'N';
	DECLARE @id int, @name varchar (120), @description varchar (1024), @location_type_category int, @sort int;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name, @description, @location_type_category, @sort;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.location_types where id = @id)
							UPDATE [dbo].[location_types] SET name = @name, description = @description, category = @location_type_category, sort = @sort, _updated_by = @updated_by, _updated_by_action = @updated_by_action where id = @id;
						ELSE
							INSERT INTO [dbo].[location_types] (id, name, description, category, sort, _updated_by, _updated_by_action) values (@id, @name, @description, @location_type_category, @sort, @updated_by, @updated_by_action);						
						UPDATE staging.location_types set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk%')
					UPDATE staging.location_types set process_status = 'E', error_message = 'Location type category not found' where id = @id;
				ELSE IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_location_type"%')
					UPDATE staging.location_types set process_status = 'E', error_message = 'location type with the given name already exists' where id = @id;
				ELSE
					UPDATE staging.location_types set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.location_types where process_status <> 'C')
END;
GO

