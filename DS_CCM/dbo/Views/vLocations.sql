CREATE view [dbo].[vLocations] as select id,dbo.getDetailsOfLocation(id) as Details,dbo.getParentsOfLocation(id) as Parents,dbo.getAccountsOfLocation(id) as Accounts,dbo.getContactsOfLocation(id) as Contacts  from locations;
GO

