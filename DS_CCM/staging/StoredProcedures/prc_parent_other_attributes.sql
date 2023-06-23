
CREATE proc [staging].[prc_parent_other_attributes](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id, attribute, value FROM [staging].[parent_other_attributes] WHERE process_status = 'N';
	DECLARE @parent_id int, @attribute int, @value varchar (120), @value_id int, @data_type varchar (10);	
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @parent_id, @attribute, @value;
				IF @@fetch_status <> 0
					break
				SET @data_type = (select data_type from dbo.parent_attributes_other where id = @attribute);
				IF (@data_type = 'lov')
					BEGIN
						SET @value_id = (select id from dbo.parent_attributes_other_values_list where attribute = @attribute and value_id = @value);
						IF (@value_id is null)
							RAISERROR('Value not found in attribute value list',16,1);
						ELSE IF exists (select 1 from dbo.parent_attributes_other_values_lov where attribute_value = @attribute and parent = @parent_id)
							UPDATE [dbo].[parent_attributes_other_values_lov] SET _updated_by = @updated_by, _updated_by_action = @updated_by_action where attribute_value = @attribute and parent = @parent_id;
						ELSE 
							INSERT INTO [dbo].[parent_attributes_other_values_lov] (id, parent, attribute_value, _updated_by, _updated_by_action) values (next value for parent_attributes_other_values_lov_seq, @parent_id, @value_id, @updated_by, @updated_by_action);
					END
				ELSE IF (@data_type = 'bool')
					BEGIN
						IF @value not in ('Y','N')
							RAISERROR('Value can only be Y/N for ''bool'' data type',16,1);
						ELSE IF exists (select 1 from dbo.parent_attributes_other_values_bool where attribute = @attribute and parent = @parent_id)
							UPDATE [dbo].[parent_attributes_other_values_bool] SET value = case @value when 'N' then 0 else 1 end, _updated_by = @updated_by, _updated_by_action = @updated_by_action where attribute = @attribute and parent = @parent_id;
						ELSE 
							INSERT INTO [dbo].[parent_attributes_other_values_bool] (id, parent, attribute, value, _updated_by, _updated_by_action) values (next value for parent_attributes_other_values_bool_seq, @parent_id, @attribute, case @value when 'N' then 0 else 1 end, @updated_by, @updated_by_action);
					END
				ELSE IF (@data_type = 'ff')
					BEGIN
						IF exists (select 1 from dbo.parent_attributes_other_values_ff where attribute = @attribute and parent = @parent_id)
							UPDATE [dbo].[parent_attributes_other_values_ff] SET value = @value, _updated_by = @updated_by, _updated_by_action = @updated_by_action where attribute = @attribute and parent = @parent_id;
						ELSE 
							INSERT INTO [dbo].[parent_attributes_other_values_ff] (id, parent, attribute, value, _updated_by, _updated_by_action) values (next value for parent_attributes_other_values_ff_seq, @parent_id, @attribute, @value, @updated_by, @updated_by_action);
					END
				ELSE
					RAISERROR('Attribute not found',16,1);
				UPDATE [staging].[parent_other_attributes] set process_status = 'C' where attribute = @attribute and parent_id = @parent_id;
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%"fk_parent_attributes_other_values_lov_customer_parents"%')
					UPDATE staging.parent_other_attributes set process_status = 'E', error_message = 'Parent not found for given lov' where attribute = @attribute and parent_id = @parent_id;
			ELSE IF (ERROR_MESSAGE() like '%"fk_parent_attributes_other_values_lov_parent_attributes_other_values_list"%')
					UPDATE staging.parent_other_attributes set process_status = 'E', error_message = 'Attribute Value not found' where attribute = @attribute and parent_id = @parent_id;
			ELSE IF (ERROR_MESSAGE() like '%"fk_parent_attributes_other_values_bool_customer_parents"%')
					UPDATE staging.parent_other_attributes set process_status = 'E', error_message = 'Parent not found for given bool' where attribute = @attribute and parent_id = @parent_id;
			ELSE IF (ERROR_MESSAGE() like '%"fk_parent_attributes_other_values_bool_parent_attributes_other"%')
					UPDATE staging.parent_other_attributes set process_status = 'E', error_message = 'BOOL Attribute not found' where attribute = @attribute and parent_id = @parent_id;
			ELSE IF (ERROR_MESSAGE() like '%"fk_parent_attributes_other_values_ff_customer_parents"%')
					UPDATE staging.parent_other_attributes set process_status = 'E', error_message = 'Parent not found for given ff' where attribute = @attribute and parent_id = @parent_id;
			ELSE IF (ERROR_MESSAGE() like '%"fk_parent_attributes_other_values_ff_parent_attributes_other"%')
					UPDATE staging.parent_other_attributes set process_status = 'E', error_message = 'FF Attribute not found' where attribute = @attribute and parent_id = @parent_id;
				ELSE
					UPDATE staging.parent_other_attributes set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where attribute = @attribute and parent_id = @parent_id;
			END CATCH
		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.parent_other_attributes where process_status <> 'C')
END;
GO

