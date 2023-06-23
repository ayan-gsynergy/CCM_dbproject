CREATE FUNCTION  [dbo].[getOpportunitiesOfParent] (@id int)  
 RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
   RETURN (
	select
		po.id,
		po.customer_parent 'parent',
		po.title,
		po.business_unit 'businessUnit',
		po.priority,
		po.sales_person 'salesPerson',
		po.service,
		po.details,
		po.sales_process 'salesProcess',
		po.competitors,
		po.assigned_to 'assignedTo',
		po._opened_on 'createdOn'
	from
		parent_opportunities po
	where
		po.customer_parent = @id for json path,
		INCLUDE_NULL_VALUES
   )  
END
GO

