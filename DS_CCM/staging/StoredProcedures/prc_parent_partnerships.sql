CREATE proc [staging].[prc_parent_partnerships](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id, partnerships, is_subscribed FROM [staging].[parent_partnerships] WHERE process_status = 'N';
	DECLARE @parent_id int, @partnerships int, @is_subscribed char (1);
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @parent_id, @partnerships, @is_subscribed;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF @is_subscribed not in ('Y','N')
							RAISERROR('is_subscribed column should only contain ''Y''/''N''',16,1)
						IF exists (select 1 from dbo.parent_attributes_partnerships_values where parent = @parent_id and attribute = @partnerships)
							UPDATE [dbo].[parent_attributes_partnerships_values] SET value = case @is_subscribed when 'N' then 0 else 1 end, _updated_by = @updated_by, _updated_by_action = @updated_by_action where parent = @parent_id and attribute = @partnerships;
						ELSE
							INSERT INTO [dbo].[parent_attributes_partnerships_values] (id, parent, attribute, value, _updated_by, _updated_by_action) values (next value for parent_attributes_partnerships_values_seq, @parent_id, @partnerships, case @is_subscribed when 'N' then 0 else 1 end, @updated_by, @updated_by_action);						
						UPDATE staging.parent_partnerships set process_status = 'C' where parent_id = @parent_id and partnerships = @partnerships;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk_parent_attributes_partnerships_values_customer_parents%')
					UPDATE staging.parent_partnerships set process_status = 'E', error_message = 'Parent not found' where parent_id = @parent_id and partnerships = @partnerships;
				ELSE IF (ERROR_MESSAGE() like '%fk_parent_attributes_partnerships_values_parent_attributes_partnerships%')
					UPDATE staging.parent_partnerships set process_status = 'E', error_message = 'Attribute (partnerships) not found' where parent_id = @parent_id and partnerships = @partnerships;
				ELSE
					UPDATE staging.parent_partnerships set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where parent_id = @parent_id and partnerships = @partnerships;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.parent_partnerships where process_status <> 'C')
END;
GO

