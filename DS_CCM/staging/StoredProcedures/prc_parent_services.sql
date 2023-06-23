CREATE proc [staging].[prc_parent_services](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id, service, is_subscribed FROM [staging].[parent_services] WHERE process_status = 'N';
	DECLARE @parent_id int, @service int, @is_subscribed char (1);
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @parent_id, @service, @is_subscribed;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF @is_subscribed not in ('Y','N')
							RAISERROR('is_subscribed column should only contain ''Y''/''N''',16,1)
						IF exists (select 1 from dbo.parent_attributes_services_values where parent = @parent_id and attribute = @service)
							UPDATE [dbo].[parent_attributes_services_values] SET value = case @is_subscribed when 'N' then 0 else 1 end, _updated_by = @updated_by, _updated_by_action = @updated_by_action where parent = @parent_id and attribute = @service;
						ELSE
							INSERT INTO [dbo].[parent_attributes_services_values] (id, parent, attribute, value, _updated_by, _updated_by_action) values (next value for parent_attributes_services_values_seq, @parent_id, @service, case @is_subscribed when 'N' then 0 else 1 end, @updated_by, @updated_by_action);
						UPDATE staging.parent_services set process_status = 'C' where parent_id = @parent_id and service = @service;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk_parent_attributes_services_values_customer_parents%')
					UPDATE staging.parent_services set process_status = 'E', error_message = 'Parent not found' where parent_id = @parent_id and service = @service;
				ELSE IF (ERROR_MESSAGE() like '%fk_parent_attributes_services_values_parent_attributes_services%')
					UPDATE staging.parent_services set process_status = 'E', error_message = 'Service not found' where parent_id = @parent_id and service = @service;
				ELSE
					UPDATE staging.parent_services set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where parent_id = @parent_id and service = @service;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.parent_services where process_status <> 'C')
END;
GO

