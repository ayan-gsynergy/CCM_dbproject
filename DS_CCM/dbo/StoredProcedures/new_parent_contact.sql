CREATE PROC [dbo].[new_parent_contact](
	@parent			Int,
	@person			Int,
	@address_type	    varchar(120),
	@created_by	        varchar(120),
	@updated_by			varchar(120),
	@updated_by_action 	varchar(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for contacts_seq;
	insert into dbo.contacts  
		(id,
		 parent ,
         person,
         address_type,
         [_created_by],
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @parent				,
         @person   ,
         @address_type,
         @created_by,
		 @updated_by		,
		 @updated_by_action )
END;
GO

