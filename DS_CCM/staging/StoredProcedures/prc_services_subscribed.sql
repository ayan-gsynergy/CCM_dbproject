CREATE proc [staging].[prc_services_subscribed](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, description, business_unit, sort FROM [staging].[services_subscribed] WHERE process_status = 'N';
	DECLARE @id int, @name varchar (120), @description varchar (1024), @business_unit varchar (10), @sort int;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name, @description, @business_unit, @sort;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.parent_attributes_services where id = @id)
							UPDATE [dbo].[parent_attributes_services] SET name = @name, description = @description, business_unit = @business_unit, sort = @sort, _updated_by = @updated_by, _updated_by_action = @updated_by_action where id = @id;
						ELSE
							INSERT INTO [dbo].[parent_attributes_services] (id, name, description, business_unit, sort, _updated_by, _updated_by_action) values (@id, @name, @description, @business_unit, @sort, @updated_by, @updated_by_action);						
						UPDATE staging.services_subscribed set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_parent_attributes_services"%')
					UPDATE staging.services_subscribed set process_status = 'E', error_message = 'Service with the given name already exists' where id = @id;
				ELSE IF (ERROR_MESSAGE() like '%fk%')
					UPDATE staging.services_subscribed set process_status = 'E', error_message = 'Business Unit not found' where id = @id;
				ELSE
					UPDATE staging.services_subscribed set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.services_subscribed where process_status <> 'C')
END;
GO

