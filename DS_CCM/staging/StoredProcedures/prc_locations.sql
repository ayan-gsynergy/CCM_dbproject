

CREATE proc [staging].[prc_locations](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, type, premise_id, pm_site_code, site_size, desired_head_count, ddbt, line_1, line_2, line_3, city, state, country, zip, po_box_number, phone_extension, phone, email, created_on, receives_offsite_gilts FROM [staging].[locations] WHERE process_status = 'N';	
	DECLARE @id int, @name varchar (120), @type int, @premise_id varchar (30), @pm_site_code varchar(20), @site_size int, @desired_head_count int, @ddbt varchar (50), @line_1 varchar (120), @line_2 varchar (120), @line_3 varchar (120), @city varchar (60), @state varchar (60), @country varchar (3), @zip varchar (20), @po_box_number varchar (20), @phone_extension varchar (10), @phone varchar (20), @email varchar (120), @created_on datetime2, @receives_offsite_gilts bit;	
	OPEN CUR; 
	WHILE 1=1
		BEGIN
			BEGIN TRY
			FETCH NEXT FROM CUR into @id, @name, @type, @premise_id, @pm_site_code, @site_size, @desired_head_count, @ddbt, @line_1, @line_2, @line_3, @city, @state, @country, @zip, @po_box_number, @phone_extension, @phone, @email, @created_on, @receives_offsite_gilts;	
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.locations where id = @id)
							UPDATE [dbo].[locations] SET name = @name, type = @type, premise_id = @premise_id, pm_site_code = @pm_site_code, site_size = @site_size, desired_head_count = @desired_head_count, ddbt = @ddbt, line_1 = @line_1, line_2 = @line_2, line_3 = @line_3, city = @city, state = @state, country = @country, zip = @zip, po_box_number = @po_box_number, phone_ext = @phone_extension, phone = @phone, email = @email, _updated_by = @updated_by, _updated_by_action = @updated_by_action, _created_on = @created_on, receives_offsite_gilts = @receives_offsite_gilts where id = @id;
						ELSE
							INSERT INTO [dbo].[locations] (id, name, type, premise_id, pm_site_code, site_size, desired_head_count, ddbt, line_1, line_2, line_3, city, state, country, zip, po_box_number, phone_ext, phone, email, _updated_by, _updated_by_action, _created_by, _created_on, receives_offsite_gilts) values (@id, @name, @type, @premise_id, @pm_site_code, @site_size, @desired_head_count, @ddbt, @line_1, @line_2, @line_3, @city, @state, @country, @zip, @po_box_number, @phone_extension, @phone, @email, @updated_by, @updated_by_action, @updated_by, @created_on, @receives_offsite_gilts);						
						UPDATE staging.locations set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%''unq_location_0''%')
					UPDATE staging.locations set process_status = 'E', error_message = 'location with the given name already exists' where id = @id;
				ELSE IF ERROR_MESSAGE() like '%''idx_premise_id_notnull''%'
					UPDATE staging.locations set process_status = 'E', error_message = 'location with the given premise id already exists' where id = @id;
				ELSE IF (ERROR_MESSAGE() like '%fk%')
					UPDATE staging.locations set process_status = 'E', error_message = 'Type (location) not found' where id = @id;
				ELSE
					UPDATE staging.locations set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH
		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.locations where process_status <> 'C')
END;
GO

