

CREATE proc [staging].[prc_customer_sage_accounts](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id,billing_account_name,sage_company,sage_company_division,sage_account_id,account_status,created_on FROM staging.customer_sage_accounts where process_status = 'N';
	DECLARE @parent_id int, @billing_account_name varchar(120),@sage_company varchar(10),@sage_company_division varchar(10),@sage_account_id varchar(24), @account_status varchar(1), @bill_id int, @div_id int, @created_on datetime2;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM cur into @parent_id,@billing_account_name,@sage_company,@sage_company_division,@sage_account_id,@account_status,@created_on;
				IF @@fetch_status <> 0
					break
				SET @bill_id = (select id from dbo.customer_billing_accounts where name = @billing_account_name and customer_parent = @parent_id);
				SET @div_id = (select id from dbo.sage_company_divisions where sage_company = @sage_company and sage_division_id = @sage_company_division);
				IF @bill_id is null
					RAISERROR('No Billing Account found with the given account name and parent id',16,1);
				IF @div_id is null
					RAISERROR('No Sage Company Division found with the given sage company and division id',16,1);
				IF @sage_account_id is null
					RAISERROR('Sage Account ID is mandatory',16,1);
				IF @account_status is null or @account_status not in ('A','I')
					RAISERROR('Account Status needs mandatorily to be either A or I',16,1)
				IF exists (select 1 from dbo.customer_sage_accounts where sage_company_division = @div_id and sage_account_id=@sage_account_id)
					update dbo.customer_sage_accounts set customer_billing_account=@bill_id, account_status=case @account_status when 'A' then 1 else 2 end,_updated_by=@updated_by, _updated_by_action=@updated_by_action, _created_on=@created_on where sage_company_division = @div_id and sage_account_id=@sage_account_id;
				ELSE
					insert into dbo.customer_sage_accounts (id,customer_billing_account,sage_company_division,sage_account_id,account_status,_updated_by,_updated_by_action,_created_by,_created_on) values(next value for customer_sage_accounts_seq,@bill_id,@div_id,@sage_account_id,case @account_status when 'A' then 1 else 2 end,@updated_by,@updated_by_action,@updated_by,@created_on);
				UPDATE staging.customer_sage_accounts set process_status = 'C' where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id;
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=547 and ERROR_MESSAGE() like '%"fk_customer_sage_accounts_customer_account_statuses"%' )
					UPDATE staging.customer_sage_accounts set process_status = 'E', error_message = 'Account Status not found' where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id;
				ELSE IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_customer_sage_account"%')
					UPDATE staging.customer_sage_accounts set process_status = 'E', error_message = 'Sage Account with the given account id already exists in the given sage company - company division' where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id;
				ELSE IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_customer_sage_account_0"%')
					UPDATE staging.customer_sage_accounts set process_status = 'E', error_message = 'Given Billing account already holds a sage account in the given sage company - company division' where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id;
				ELSE IF (ERROR_NUMBER()=50000)
					UPDATE staging.customer_sage_accounts set process_status = 'E', error_message = ERROR_MESSAGE() where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id;
				ELSE
					UPDATE staging.customer_sage_accounts set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id;
			END CATCH
		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.customer_sage_accounts where process_status <> 'C')
END;
GO

