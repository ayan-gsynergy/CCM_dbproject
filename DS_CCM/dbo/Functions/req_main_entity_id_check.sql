create function dbo.req_main_entity_id_check(
@entity varchar(30),
@entity_id int
)
RETURNS bit
AS
BEGIN
	DECLARE @retval bit;
	If (@entity = 'Parents')
		SELECT @retval= count(*) from dbo.customer_parents where id = @entity_id;
	ELSE IF (@entity = 'Accounts')
		SELECT @retval= count(*) from dbo.customer_billing_accounts where id = @entity_id;
	ELSE IF (@entity = 'Contacts')
		SELECT @retval= count(*) from dbo.persons where id = @entity_id;
	ELSE IF (@entity = 'Locations')
		SELECT @retval= count(*) from dbo.locations where id = @entity_id;
	ELSE
		SET @retval = 0;
	RETURN @retval
END;
GO

