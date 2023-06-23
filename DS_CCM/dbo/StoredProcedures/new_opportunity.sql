CREATE PROC dbo.new_opportunity(
	@parent	            INT,
	@title				varchar(120),
	@businessUnit	    varchar(10),
	@priority			INT,
	@salesPerson	    INT,
	@service			INT,
	@details			varchar(1024),
	@salesProcess	    INT,
	@competitors		varchar(120),
	@assignedTo			varchar(10),
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for parent_opportunities_seq;
	insert into dbo.parent_opportunities 
		(id,
         customer_parent,
		 title ,
		 business_unit ,
		 priority ,
		 sales_person ,
		 service ,
		 details ,
		 sales_process ,
		 competitors ,
		 assigned_to ,
		 _updated_by,
		 _updated_by_action)
		 values(
		 @id,
		 @parent				,
         @title   ,
		 @businessUnit				,
		 @priority			,
		 @salesPerson				,
		 @service			,
		 @details			,
		 @salesProcess			,
		 @competitors				,
		 @assignedTo			,
		 @updated_by		,
		 @updated_by_action)
END;
GO

