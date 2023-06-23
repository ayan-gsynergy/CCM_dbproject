CREATE PROC dbo.new_customer_sage_account(
	@customer_billing_account	INT,
	@sage_company_division_id   INT,
	@created_by					varchar(120),
	@updated_by					varchar(120),
	@updated_by_action 			char(32),
	@id							INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for customer_sage_accounts_seq;
	insert into dbo.customer_sage_accounts
		(id,
		 customer_billing_account,
		 sage_company_division,
		 sage_account_id,
		 _created_by,
		 _updated_by,
		 _updated_by_action)
	values(
		 @id,
		 @customer_billing_account	,
		 @sage_company_division_id							,
		 NULL,
		 @created_by,
		 @updated_by				,
		 @updated_by_action)
END;
GO

