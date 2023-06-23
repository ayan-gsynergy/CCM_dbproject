CREATE view [dbo].[vAccounts] as select id,dbo.getDetailsOfAccount(id) as Details,dbo.getContactsOfAccount(id) as Contacts,dbo.getLocationsOfAccount(id) as Locations  from customer_billing_accounts;
GO

