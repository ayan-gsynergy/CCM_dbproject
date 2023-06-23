CREATE PROC [dbo].[update_distribution_list](
    @id                 Int,
	@name			        VarChar(120),
	@description			VarChar(1024),
	@updated_by			    Varchar(120),
	@updated_by_action 	    char(32))
AS
BEGIN
	SET NOCOUNT ON;
	 UPDATE distribution_lists  
       SET name = COALESCE( @name, name),
       description = COALESCE( @description,description),
          [_updated_by]=  @updated_by,
          [_updated_by_action] = @updated_by_action 
          WHERE id = @id;
END;
GO

