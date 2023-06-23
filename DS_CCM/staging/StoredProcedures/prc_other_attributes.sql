CREATE proc [staging].[prc_other_attributes](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, description, data_type, sort FROM [staging].[other_attributes] WHERE process_status = 'N';
	DECLARE @id int, @name varchar (120), @description varchar (1024), @data_type varchar (20), @sort int;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name, @description, @data_type, @sort;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.parent_attributes_other where id = @id)
							UPDATE [dbo].[parent_attributes_other] SET name = @name, description = @description, data_type = @data_type, sort = @sort, _updated_by = @updated_by, _updated_by_action = @updated_by_action where id = @id;
						ELSE
							INSERT INTO [dbo].[parent_attributes_other] (id, name, description, data_type, sort, _updated_by, _updated_by_action) values (@id, @name, @description, @data_type, @sort, @updated_by, @updated_by_action);						
						UPDATE staging.other_attributes set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_parent_attributes_other"%')
					UPDATE staging.other_attributes set process_status = 'E', error_message = 'Attribute with the given name already exists' where id = @id;
				ELSE
					UPDATE staging.other_attributes set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.other_attributes where process_status <> 'C')
END;
GO

