CREATE PROC [dbo].[new_contact_location](
	@contact			Int,
	@location			Int,
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
UPDATE contacts SET location = @location where id = @contact;
END;
GO

