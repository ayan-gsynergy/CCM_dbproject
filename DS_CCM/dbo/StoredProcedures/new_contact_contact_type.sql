CREATE PROC [dbo].[new_contact_contact_type](
	@contact			Int,
	@contact_type	    Int,
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for contact_contact_types_seq;
	insert into dbo.contact_contact_types  
		(id,
		 contact  ,
         contact_type  ,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @contact				,
         @contact_type   ,
		 @updated_by		,
		 @updated_by_action )
END;
GO

