CREATE PROC [dbo].[new_contact_distribution](
	@contact			Int,
	@distribution_list	    Int,
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for contact_distribution_list_seq;
	insert into dbo.contact_distribution_list  
		(id,
		 contact  ,
        distribution_list   ,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @contact				,
         @distribution_list   ,
		 @updated_by		,
		 @updated_by_action )
END;
GO

