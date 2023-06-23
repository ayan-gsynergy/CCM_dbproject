CREATE PROC [dbo].[new_distribution_list](
	@name			        VarChar(120),
	@description			VarChar(1024),
	@updated_by			    Varchar(120),
	@updated_by_action 	    char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for distribution_lists_seq;
	insert into dbo.distribution_lists 
		(id,
		 name ,
         description ,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @name				,
         @description   ,
		 @updated_by		,
		 @updated_by_action )
END;
GO

