




CREATE proc [staging].[prc_customer_sage_acc_contacts](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	merge into staging.customer_sage_acc_contacts d
	using (select sage_company,sage_company_division,sage_account_id,person_id,contact_type 
			from( select first_value(address_type) over(partition by sage_company,sage_company_division,sage_account_id,person_id order by sage_company,sage_company_division,sage_account_id,person_id) as f_address_type,
					* from staging.customer_sage_acc_contacts
				) a
			where ISNULL(address_type,'CCM_PRIMARY')<>ISNULL(f_address_type,'CCM_PRIMARY')
		  ) s
	on (d.sage_company = s.sage_company and d.sage_company_division=s.sage_company_division and d.sage_account_id=s.sage_account_id and d.person_id = s.person_id and d.contact_type = s.contact_type)
	when matched then update set process_status = 'E',
		error_message = 'A contact with a contact type given with the same sage_company division-account_id and person but with a different address type';
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id,sage_company,sage_company_division,sage_account_id,person_id,ct.value contact_type,address_type,dl.value distribution_list FROM staging.customer_sage_acc_contacts cross apply string_split(contact_type,',') ct outer apply string_split(distribution_list,',') dl where process_status = 'N';
	DECLARE @parent_id int,@sage_company varchar(10),@sage_company_division varchar(10), @sage_account_id varchar(24),@person_id int,@contact_type varchar(max),@address_type varchar(120),@distribution_list varchar(max),@contact_id int,@sage_account_dbid int,@div_id int,@bill_id int,@ct_err varchar(300),@dl_err varchar(300);
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM cur into @parent_id,@sage_company,@sage_company_division,@sage_account_id,@person_id,@contact_type,@address_type,@distribution_list;
				IF @@fetch_status <> 0
					break
				IF not exists (select 1 from dbo.persons where id = @person_id)
					RAISERROR('Person not found',16,1);
				SET @div_id = (select id from dbo.sage_company_divisions where sage_company = @sage_company and sage_division_id = @sage_company_division);
				IF @div_id is null
					RAISERROR('No Sage Company Division found with the given sage company and division id',16,1);
				SET @sage_account_dbid = null;
				SET @bill_id = null;
				select @sage_account_dbid = id, @bill_id = customer_billing_account from dbo.customer_sage_accounts where sage_company_division=@div_id and sage_account_id = @sage_account_id;
				IF @sage_account_dbid is null
					RAISERROR('No Sage Account found with the given account id in the given sage company and division',16,1);
				IF not exists (select 1 from dbo.customer_parents where id = @parent_id)
					RAISERROR('Parent not found',16,1);
				IF @parent_id <> (select customer_parent from dbo.customer_billing_accounts where id = @bill_id)
					RAISERROR('Given sage account and parent id don''t match',16,1);
				IF not (@address_type in ('CCM_PRIMARY','CCM_BILLING_INFO','CCM_PARENT_INFO','CCM_LOCATION_INFO') or exists (select 1 from dbo.person_adrs_ph_email where person = @person_id and type=@address_type))
					RAISERROR('Address type neither a reserved type nor among the given types for the person',16,1)
				SET @contact_id = (select id from dbo.contacts where sage_account =@sage_account_dbid and person = @person_id and location is null);
				IF @contact_id is not null
					BEGIN
						update dbo.contacts set address_type = @address_type,_updated_by=@updated_by,_updated_by_action=@updated_by_action where sage_account =@sage_account_dbid and person = @person_id and location is null;
						IF EXISTS (select 1 from dbo.contact_contact_types where contact = @contact_id and contact_type = @contact_type )
							update dbo.contact_contact_types set _updated_by=@updated_by,_updated_by_action=@updated_by_action where contact = @contact_id and contact_type = @contact_type;
						ELSE
							insert into dbo.contact_contact_types(id,contact,contact_type,_updated_by,_updated_by_action) values (next value for contact_contact_types_seq, @contact_id,@contact_type,@updated_by,@updated_by_action);
						IF @distribution_list is not null
							IF EXISTS (select 1 from dbo.contact_distribution_list where contact = @contact_id and distribution_list = @distribution_list)
								update dbo.contact_distribution_list set _updated_by=@updated_by,_updated_by_action=@updated_by_action where contact = @contact_id and distribution_list = @distribution_list;
							ELSE
								insert into dbo.contact_distribution_list(id,contact,distribution_list,_updated_by,_updated_by_action) values (next value for contact_distribution_list_seq, @contact_id,@distribution_list,@updated_by,@updated_by_action);
					END
				ELSE
					BEGIN
						SET @contact_id = next value for contacts_seq;
						insert into dbo.contacts (id,sage_account,person,address_type,_updated_by,_created_by,_updated_by_action) values(@contact_id,@sage_account_dbid,@person_id,@address_type,@updated_by,@updated_by,@updated_by_action);
						insert into dbo.contact_contact_types(id,contact,contact_type,_updated_by,_updated_by_action) values (next value for contact_contact_types_seq, @contact_id,@contact_type,@updated_by,@updated_by_action);
						IF @distribution_list is not null
							insert into dbo.contact_distribution_list(id,contact,distribution_list,_updated_by,_updated_by_action) values (next value for contact_distribution_list_seq, @contact_id,@distribution_list,@updated_by,@updated_by_action);					
					END
				UPDATE staging.customer_sage_acc_contacts set process_status = 'C' where sage_company=@sage_company and sage_company_division=@sage_company_division and sage_account_id=@sage_account_id and person_id=@person_id and error_message is null;
			END TRY
		
			BEGIN CATCH
--				IF (ERROR_NUMBER()=547 and ERROR_MESSAGE() like '%"fk_contacts_customer_parents"%' )
--					UPDATE staging.customer_sage_acc_contacts set process_status = 'E', error_message = 'Parent not found' where sage_company=@sage_company and sage_company_division=@sage_company_division and sage_account_id=@sage_account_id and person_id=@person_id;
--				ELSE IF (ERROR_NUMBER()=547 and ERROR_MESSAGE() like '%"fk_contacts_persons"%' )
--					UPDATE staging.customer_sage_acc_contacts set process_status = 'E', error_message = 'Person not found' where sage_company=@sage_company and sage_company_division=@sage_company_division and sage_account_id=@sage_account_id and person_id=@person_id;
				IF (ERROR_NUMBER()=547 and ERROR_MESSAGE() like '%"fk_contact_contact_types_contact_types"%' )
					BEGIN
						IF @ct_err is null
							set @ct_err = 'Contact type not found - ' + @contact_type;
						ELSE
							set @ct_err = @ct_err + ',' + @contact_type;
						UPDATE staging.customer_sage_acc_contacts set process_status = 'E', error_message = @ct_err where sage_company=@sage_company and sage_company_division=@sage_company_division and sage_account_id=@sage_account_id and person_id=@person_id;
					END
				ELSE IF (ERROR_NUMBER()=547 and ERROR_MESSAGE() like '%"fk_contact_distribution_list_distribution_lists"%' )
					BEGIN
						IF @dl_err is null
							set @dl_err = 'Distribution list not found - ' + @distribution_list;
						ELSE
							set @dl_err = @dl_err + ',' + @distribution_list;
						UPDATE staging.customer_sage_acc_contacts set process_status = 'E', error_message = @dl_err where sage_company=@sage_company and sage_company_division=@sage_company_division and sage_account_id=@sage_account_id and person_id=@person_id;
					END
				ELSE IF ERROR_NUMBER() = 50000
					UPDATE staging.customer_sage_acc_contacts set process_status = 'E', error_message = ERROR_MESSAGE()  where sage_company=@sage_company and sage_company_division=@sage_company_division and sage_account_id=@sage_account_id and person_id=@person_id;
				ELSE
					UPDATE staging.customer_sage_acc_contacts set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where sage_company=@sage_company and sage_company_division=@sage_company_division and sage_account_id=@sage_account_id and person_id=@person_id;
			END CATCH
		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.customer_sage_acc_contacts where process_status <> 'C')
END;;
GO

