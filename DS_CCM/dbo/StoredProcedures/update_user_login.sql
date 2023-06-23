CREATE PROC [dbo].[update_user_login](
	@name			    varchar(120),
	@groups			    varchar(120))
AS
BEGIN
	UPDATE dbo.user_login  
       SET groups  = COALESCE(@groups, groups),
          last_logged_in  = getutcdate()
       WHERE name = @name;
END;
GO

