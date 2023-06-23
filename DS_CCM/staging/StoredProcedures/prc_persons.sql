

CREATE proc [staging].[prc_persons](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	update staging.persons set process_status='E', error_message = 'No address type marked as primary for this person' 
	where id in (
	select id from staging.persons as sp where not exists (select 1 from dbo.persons as dp where dp.id = sp.id) 
	group by id having max(is_primary) = 'N');

	update staging.persons set process_status='E', error_message = 'Multiple address types marked as primary for this person' 
	where id in (
	select id from staging.persons group by id having sum(case when is_primary = 'Y' then 1 else 0 end)>1);
	
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id,name_first,name_middle,name_last,is_internal,address_type,is_primary,line_1,line_2,line_3,city,state,country,zip,po_box_number,phone_extension,phone,email,created_on FROM staging.persons where process_status = 'N' order by id,address_type;
	DECLARE @id int,@name_first varchar(120),@name_middle varchar(120),@name_last varchar(120),@is_internal char(1),@address_type varchar(120),@is_primary varchar(1),@line_1 varchar(120),@line_2 varchar(120),@line_3 varchar(120),@city varchar(60),@state varchar(60),@country varchar(3),@zip varchar(20),@po_box_number varchar(20),@phone_ext varchar(10),@phone varchar(20),@email varchar(120),@adr_id int,@created_on datetime2;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM cur into @id,@name_first,@name_middle,@name_last,@is_internal,@address_type,@is_primary,@line_1,@line_2,@line_3,@city,@state,@country,@zip,@po_box_number,@phone_ext,@phone,@email,@created_on;
				IF @@fetch_status <> 0
					break
				IF exists (select 1 from dbo.persons where id=@id)
					update dbo.persons set name_first = @name_first,name_last=@name_last,name_middle=@name_middle,is_internal=case @is_internal when 'Y' then 1 else 0 end,_updated_by=@updated_by,_updated_by_action=@updated_by_action,_created_on=@created_on where id=@id;
				ELSE
					insert into dbo.persons (id,name_first,name_last,name_middle,is_internal,_updated_by,_updated_by_action,_created_by,_created_on) values(@id,@name_first,@name_last,@name_middle,case @is_internal when 'Y' then 1 else 0 end,@updated_by,@updated_by_action,@updated_by,@created_on);
				SET @adr_id = (select id from dbo.person_adrs_ph_email where person = @id and type = @address_type);
				IF @adr_id is not null
					update dbo.person_adrs_ph_email set phone=@phone,phone_ext=@phone_ext,email=@email,line_1=@line_1,line_2=@line_2,line_3=@line_3,city=@city,state=@state,country=@country,zip=@zip,po_box_number=@po_box_number,_updated_by=@updated_by,_updated_by_action=@updated_by_action where id = @adr_id;
				ELSE
					begin
						SET @adr_id = next value for person_adrs_ph_email_seq;
						insert into dbo.person_adrs_ph_email (id,person,type,phone,phone_ext,email,line_1,line_2,line_3,city,state,country,zip,po_box_number,_updated_by,_updated_by_action) values (@adr_id, @id,@address_type,@phone,@phone_ext,@email,@line_1,@line_2,@line_3,@city,@state,@country,@zip,@po_box_number,@updated_by,@updated_by_action);
					end
				IF (@is_primary = 'Y')
					update dbo.persons set primary_adrs_ph_email=@adr_id where id=@id;
				UPDATE staging.persons set process_status = 'C' where id=@id and address_type=@address_type;
			END TRY
		
			BEGIN CATCH
				UPDATE staging.persons set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id=@id and address_type=@address_type;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.persons where process_status <> 'C')
END;
GO

