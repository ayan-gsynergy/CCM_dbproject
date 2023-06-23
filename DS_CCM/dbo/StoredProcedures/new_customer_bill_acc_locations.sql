CREATE PROC dbo.new_customer_bill_acc_locations(
	@customer_billing_account				INT,
	@location			Int,
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for customer_bill_acc_locations_seq;
	insert into dbo.customer_bill_acc_locations 
		(id,
		 customer_billing_account ,
         location ,
         is_active ,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @customer_billing_account				,
         @location   ,
         1,
		 @updated_by		,
		 @updated_by_action )
END;
GO

