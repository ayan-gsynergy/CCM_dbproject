CREATE PROC [dbo].[new_sage_division_contacts](
	@sage_account			Int,
	@contact			            Int,
	@sage_contact_code	            varchar(24) = NULL,
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for sage_account_contacts_seq;
	insert into dbo.sage_account_contacts  
		(id,
		 sage_account,
         contact ,
         sage_contact_code)
	values 
		(@id,
		 @sage_account				,
         @contact   ,
         @sage_contact_code)
END;
GO

