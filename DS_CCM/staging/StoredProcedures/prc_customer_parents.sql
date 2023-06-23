
CREATE proc [staging].[prc_customer_parents](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, type, production_type, estimated_sows, estimated_hogs, phone, phone_extension, email, attention_to, line_1, line_2, line_3, city, state, country, zip, po_box_number,created_on FROM [staging].[customer_parents] WHERE process_status = 'N';
	DECLARE @id int, @name varchar (120), @type int, @production_type int, @estimated_sows int, @estimated_hogs int, @phone varchar (20), @phone_extension varchar (10), @email varchar (120), @attention_to varchar (120), @line_1 varchar (120), @line_2 varchar (120), @line_3 varchar (120), @city varchar (60), @state varchar (60), @country varchar (3), @zip varchar (20), @po_box_number varchar (20), @created_on datetime2;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name, @type, @production_type, @estimated_sows, @estimated_hogs, @phone, @phone_extension, @email, @attention_to, @line_1, @line_2, @line_3, @city, @state, @country, @zip, @po_box_number, @created_on;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.customer_parents where id = @id)
							UPDATE [dbo].[customer_parents] SET name = @name, type = @type, production_type = @production_type, estimated_sows = @estimated_sows, estimated_hogs = @estimated_hogs, phone = @phone, phone_ext = @phone_extension, email = @email, attention_to = @attention_to, line_1 = @line_1, line_2 = @line_2, line_3 = @line_3, city = @city, state = @state, country = @country, zip = @zip, po_box_number = @po_box_number, _updated_by = @updated_by, _updated_by_action = @updated_by_action,_created_on=@created_on where id = @id;
						ELSE
							INSERT INTO [dbo].[customer_parents] (id, name, type, production_type, estimated_sows, estimated_hogs, phone, phone_ext, email, attention_to, line_1, line_2, line_3, city, state, country, zip, po_box_number, _updated_by, _updated_by_action, _created_by,_created_on) values (@id, @name, @type, @production_type, @estimated_sows, @estimated_hogs, @phone, @phone_extension, @email, @attention_to, @line_1, @line_2, @line_3, @city, @state, @country, @zip, @po_box_number, @updated_by, @updated_by_action, @updated_by,@created_on);						
						UPDATE staging.customer_parents set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk_customer_parents_customer_parent_types%')
					UPDATE staging.customer_parents set process_status = 'E', error_message = 'Parent Type not found' where id = @id;
				ELSE IF (ERROR_MESSAGE() like '%fk_customer_parents_production_types%')
					UPDATE staging.customer_parents set process_status = 'E', error_message = 'Parent Production Type not found' where id = @id;
				ELSE
					UPDATE staging.customer_parents set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.customer_parents where process_status <> 'C')
END;
GO

