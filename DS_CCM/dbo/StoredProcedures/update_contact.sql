CREATE PROC [dbo].[update_contact](
    @id                 Int,
	@is_active          Int = NULL,
	@address_type       varchar(120) = NULL,
	@updated_by			varchar(120),
	@updated_by_action 	char(32))
AS
BEGIN
	SET NOCOUNT ON;
	 UPDATE contacts  
       SET is_active = COALESCE(@is_active,is_active),
           address_type  = COALESCE (@address_type,address_type),
          [_updated_by]=  @updated_by,
          [_updated_by_action] = @updated_by_action 
          WHERE id = @id;
END;
GO

