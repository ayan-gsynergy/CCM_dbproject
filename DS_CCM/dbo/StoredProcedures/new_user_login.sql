CREATE PROC [dbo].[new_user_login](
	@id			        varchar(120),
	@name			        varchar(120),
	@groups			    varchar(120))
AS
BEGIN
	INSERT INTO dbo.user_login (id, name, groups, last_logged_in) 
          values(@id ,@name, @groups, getutcdate());
END;
GO

