CREATE PROC [dbo].[new_parent_location](
	@parent			Int,
	@location			Int,
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for parent_locations_seq;
	insert into dbo.parent_locations 
		(id,
		 parent ,
         location ,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @parent				,
         @location   ,
		 @updated_by		,
		 @updated_by_action )
END;
GO

