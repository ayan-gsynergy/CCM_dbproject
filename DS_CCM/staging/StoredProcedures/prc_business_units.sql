CREATE proc [staging].[prc_business_units](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, description, sort FROM [staging].[business_units] WHERE process_status = 'N';
	DECLARE @id varchar(6), @name varchar (120), @description varchar (1024), @sort int;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name, @description, @sort;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.business_units where id = @id)
							UPDATE [dbo].[business_units] SET name = @name, description = @description, sort = @sort, _updated_by = @updated_by, _updated_by_action = @updated_by_action where id = @id;
						ELSE
							INSERT INTO [dbo].[business_units] (id, name, description, sort, _updated_by, _updated_by_action) values (@id, @name, @description, @sort, @updated_by, @updated_by_action);						
						UPDATE staging.business_units set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_business_units"%')
					UPDATE staging.business_units set process_status = 'E', error_message = 'Business Unit with the given name already exists' where id = @id;
				ELSE
					UPDATE staging.business_units set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.business_units where process_status <> 'C')
END;
GO

