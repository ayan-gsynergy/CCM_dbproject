CREATE PROC [dbo].[new_sage_acc_location](
	@sageAccId			Int,
	@locationId			Int,
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for customer_sage_acc_locations_seq;
	insert into dbo.customer_sage_acc_locations  
		(id,
		 customer_sage_account  ,
         location ,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @sageAccId				,
         @locationId   ,
		 @updated_by		,
		 @updated_by_action )
END;
GO

