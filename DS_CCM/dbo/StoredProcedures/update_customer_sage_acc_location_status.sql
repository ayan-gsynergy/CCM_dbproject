CREATE PROC [dbo].[update_customer_sage_acc_location_status](
    @id                 Int,
	@is_active           Int = NULL,
	@updated_by			varchar(120),
	@updated_by_action 	char(32))
AS
BEGIN
	SET NOCOUNT ON;
	 UPDATE dbo.customer_sage_acc_locations  
       SET is_active = COALESCE(@is_active, is_active),
          [_updated_by]=  @updated_by,
          [_updated_by_action] = @updated_by_action 
          WHERE id = @id;
END;
GO

