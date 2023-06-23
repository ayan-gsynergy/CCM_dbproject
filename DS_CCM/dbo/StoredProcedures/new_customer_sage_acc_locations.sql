CREATE PROC dbo.new_customer_sage_acc_locations(
	@customer_sage_account				INT,
	@location			Int,
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for customer_sage_acc_locations_seq;
	insert into dbo.customer_sage_acc_locations 
		(id,
		 customer_sage_account ,
         location ,
         is_active ,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @customer_sage_account				,
         @location   ,
         1,
		 @updated_by		,
		 @updated_by_action )
END;
GO

