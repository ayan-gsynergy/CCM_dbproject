

CREATE proc [staging].[prc_customer_sage_acc_locations](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT parent_id,sage_company,sage_company_division,sage_account_id,location_id,sage_ship_to_code,is_active FROM staging.customer_sage_acc_locations where process_status = 'N';
	DECLARE @parent_id int, @sage_company varchar(10),@sage_company_division varchar(10),@sage_account_id varchar(24),@location_id int, @sage_ship_to_code varchar(24), @is_active varchar(1),@div_id int,@bill_id int, @sage_account_dbid int;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM cur into @parent_id, @sage_company,@sage_company_division,@sage_account_id,@location_id, @sage_ship_to_code, @is_active;
				IF @@fetch_status <> 0
					break
				SET @div_id = (select id from dbo.sage_company_divisions where sage_company = @sage_company and sage_division_id = @sage_company_division);
				IF @div_id is null
					RAISERROR('No Sage Company Division found with the given sage company and division id',16,1);
				SET @sage_account_dbid = null;
				SET @bill_id = null;
				select @sage_account_dbid = id, @bill_id = customer_billing_account from dbo.customer_sage_accounts where sage_company_division=@div_id and sage_account_id = @sage_account_id;
				IF @sage_account_dbid is null
					RAISERROR('No Sage Account found with the given account id in the given sage company and division',16,1);
				IF @parent_id <> (select customer_parent from dbo.customer_billing_accounts where id = @bill_id)
					RAISERROR('Given sage account and parent id don''t match',16,1);
				IF @is_active not in ('Y','N') or @is_active is null
					RAISERROR('Acceptable values for is_active column are ''Y'' and ''N'' only',16,1)
				IF exists (select 1 from dbo.customer_sage_acc_locations where customer_sage_account=@sage_account_dbid and location = @location_id)
					update dbo.customer_sage_acc_locations set sage_ship_to_code = @sage_ship_to_code, is_active = case @is_active when 'N' then 0 else 1 end ,_updated_by=@updated_by, _updated_by_action=@updated_by_action where customer_sage_account=@sage_account_dbid and location = @location_id;
				ELSE
					insert into dbo.customer_sage_acc_locations (id,customer_sage_account,location,sage_ship_to_code,is_active,_updated_by,_updated_by_action) values(next value for customer_sage_acc_locations_seq,@sage_account_dbid,@location_id,@sage_ship_to_code,case @is_active when 'N' then 0 else 1 end,@updated_by,@updated_by_action);
				UPDATE staging.customer_sage_acc_locations set process_status = 'C' where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id and location_id = @location_id;
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=547 and ERROR_MESSAGE() like '%"fk_customer_sage_acc_locations_locations"%' )
					UPDATE staging.customer_sage_acc_locations set process_status = 'E', error_message = 'Location not found' where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id and location_id = @location_id;
				ELSE IF (ERROR_NUMBER()=50000)
					UPDATE staging.customer_sage_acc_locations set process_status = 'E', error_message = ERROR_MESSAGE() where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id and location_id = @location_id;
				ELSE
					UPDATE staging.customer_sage_acc_locations set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where sage_company = @sage_company and sage_company_division=@sage_company_division and sage_account_id = @sage_account_id and location_id = @location_id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.customer_sage_acc_locations where process_status <> 'C')
END;
GO

