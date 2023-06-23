CREATE PROC dbo.update_opportunity(
	@id	            INT,
	@title				varchar(120) = NULL,
	@businessUnit	    varchar(10) = NULL,
	@priority			INT = NULL,
	@salesPerson	    INT = NULL,
	@service			INT = NULL,
	@details			varchar(1024) = NULL,
	@salesProcess	    INT = NULL,
	@competitors		varchar(120) = NULL,
	@assignedTo			varchar(10) = NULL,
	@updated_by			varchar(120),
	@updated_by_action 	char(32))
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE parent_opportunities  
          SET title = COALESCE(@title, title),
          business_unit = COALESCE(@businessUnit, business_unit),
          priority = COALESCE(@priority, priority),
          sales_person = CASE WHEN @salesPerson = '-1' THEN NULL ELSE COALESCE(@salesPerson, sales_person) END,
          service = COALESCE(@service, service),
          details = COALESCE(@details, details),
          sales_process = COALESCE(@salesProcess, sales_process),
          competitors = COALESCE(@competitors, competitors),
          assigned_to = CASE WHEN @assignedTo = '-1' THEN NULL ELSE COALESCE(@assignedTo, assigned_to) END,
          [_updated_by] = COALESCE(@updated_by, _updated_by),
          [_updated_by_action]  = COALESCE(@updated_by_action, _updated_by_action)
          WHERE id = @id;
	
END;
GO

