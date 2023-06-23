CREATE PROC [dbo].[update_sage_account](
    @id             Int,
    @billAccId      Int = NULL,
	@sageAcctId	    varchar(24) = NULL,
	@status         INT = NULL,
	@updated_by     varchar(120) = NULL,
	@updated_by_action varchar(32) = NULL)
AS
BEGIN
	SET NOCOUNT ON;
	 UPDATE customer_sage_accounts  
       SET sage_account_id  = COALESCE(@sageAcctId, sage_account_id),
       customer_billing_account  = COALESCE(@billAccId, customer_billing_account),
       account_status = COALESCE(@status, account_status),
       [_updated_by] = COALESCE(@updated_by, _updated_by),
       [_updated_by_action] = COALESCE(@updated_by_action, _updated_by_action)
            WHERE id  = @id;
END;
GO

