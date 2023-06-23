CREATE proc [staging].[prc_customer_billing_accounts](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id, name, attention_to, line_1, line_2, line_3, city, state, country, zip, po_box_number, phone_extension, phone, email, created_on FROM [staging].[customer_billing_accounts] WHERE process_status = 'N';
	DECLARE @parent_id int, @name varchar (120), @attention_to varchar (120), @line_1 varchar (120), @line_2 varchar (120), @line_3 varchar (120), @city varchar (60), @state varchar (60), @country varchar (3), @zip varchar (20), @po_box_number varchar (20), @phone_extension varchar (10), @phone varchar (20), @email varchar (120), @created_on datetime2;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @parent_id, @name, @attention_to, @line_1, @line_2, @line_3, @city, @state, @country, @zip, @po_box_number, @phone_extension, @phone, @email, @created_on;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.customer_billing_accounts where customer_parent = @parent_id and name = @name)
							UPDATE [dbo].[customer_billing_accounts] SET attention_to = @attention_to, line_1 = @line_1, line_2 = @line_2, line_3 = @line_3, city = @city, state = @state, country = @country, zip = @zip, po_box_number = @po_box_number, phone_ext = @phone_extension, phone = @phone, email = @email, _updated_by = @updated_by, _updated_by_action = @updated_by_action, _created_on = @created_on where customer_parent = @parent_id and name = @name;
						ELSE
							INSERT INTO [dbo].[customer_billing_accounts] (id, customer_parent, name, attention_to, line_1, line_2, line_3, city, state, country, zip, po_box_number, phone_ext, phone, email, _updated_by, _updated_by_action, _created_by, _created_on) values (next value for customer_billing_accounts_seq, @parent_id, @name, @attention_to, @line_1, @line_2, @line_3, @city, @state, @country, @zip, @po_box_number, @phone_extension, @phone, @email, @updated_by, @updated_by_action, @updated_by, @created_on);						
						UPDATE staging.customer_billing_accounts set process_status = 'C' where parent_id = @parent_id and name = @name;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk%')
					UPDATE staging.customer_billing_accounts set process_status = 'E', error_message = 'Customer Parent not found' where parent_id = @parent_id and name = @name;
				ELSE
					UPDATE staging.customer_billing_accounts set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where parent_id = @parent_id and name = @name;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.customer_billing_accounts where process_status <> 'C')
END;
GO

