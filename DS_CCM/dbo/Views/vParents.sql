


CREATE view [dbo].[vParents] as select id,dbo.getDetailsOfParent(id) as Details, dbo.getAccountsOfParent(id) as Accounts, dbo.getContactsOfParent(id) as Contacts, dbo.getLocationsOfParent(id) as Locations,  dbo.getOpportunitiesOfParent(id) as Opportunities from customer_parents;
GO

