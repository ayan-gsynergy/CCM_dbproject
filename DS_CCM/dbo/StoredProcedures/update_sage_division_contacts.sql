CREATE procedure [dbo].[update_sage_division_contacts] (
          @id                               INT,
          @sage_contact_code	            varchar(24))
          AS
          BEGIN
          SET NOCOUNT ON;
          UPDATE sage_account_contacts  
          SET sage_contact_code = @sage_contact_code
          WHERE id  = @id;
          END
GO

