CREATE view [dbo].vContacts as select id,dbo.getDetailsOfContact(id) as Details,dbo.getParentsOfContact(id) as Parents,dbo.getAccountsOfContact(id) as Accounts,dbo.getLocationsOfContact(id) as Locations  from persons;
GO

