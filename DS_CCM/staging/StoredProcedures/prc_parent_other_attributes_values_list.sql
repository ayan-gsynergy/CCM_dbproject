CREATE proc [staging].[prc_parent_other_attributes_values_list](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT attribute, value_id, value_name, value_description, value_sort FROM [staging].[parent_other_attributes_values_list] WHERE process_status = 'N';
	DECLARE @attribute int, @value_id int, @value_name varchar (120), @value_description varchar (1024), @value_sort int, @data_type varchar (10);	
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @attribute, @value_id, @value_name, @value_description, @value_sort;
				IF @@fetch_status <> 0
					break
				SET @data_type = (select data_type from dbo.parent_attributes_other where id = @attribute);
				IF (@data_type is null)
					RAISERROR('Attribute doesn''t exist',16,1);
				ELSE IF (@data_type <> 'lov')
					RAISERROR('Attribute not of type - LOV',16,1);
				ELSE
					BEGIN
						IF exists (select 1 from dbo.parent_attributes_other_values_list where attribute = @attribute and value_id = @value_id)
							UPDATE [dbo].[parent_attributes_other_values_list] SET value_name = @value_name, value_description = @value_description, sort = @value_sort, _updated_by = @updated_by, _updated_by_action = @updated_by_action  where attribute = @attribute and value_id = @value_id;
						ELSE
							INSERT INTO [dbo].[parent_attributes_other_values_list] (id, attribute, value_id, value_name, value_description, sort, _updated_by, _updated_by_action) values (next value for parent_attributes_other_values_list_seq, @attribute, @value_id, @value_name, @value_description, @value_sort, @updated_by, @updated_by_action);						
						UPDATE staging.parent_other_attributes_values_list set process_status = 'C' where attribute = @attribute and value_id = @value_id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_parent_attributes_other_values_list_value_name"%')
					UPDATE staging.parent_other_attributes_values_list set process_status = 'E', error_message = 'Attribute value with the given name already exists for this attribute' where attribute = @attribute and value_id = @value_id;
				ELSE IF (ERROR_MESSAGE() like '%fk%')
					UPDATE staging.parent_other_attributes_values_list set process_status = 'E', error_message = 'Attribute not found' where attribute = @attribute and value_id = @value_id;
				ELSE
					UPDATE staging.parent_other_attributes_values_list set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where attribute = @attribute and value_id = @value_id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.parent_other_attributes_values_list where process_status <> 'C')
END;
GO

