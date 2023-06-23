CREATE PROC [dbo].[new_request_maintenance](
	@entity		           varchar(30),
	@entityId			   int,
	@tab                   varchar(30),
	@message               varchar(1024),
	@isResolved            bit,
	@createdBy             varchar(120),
	@updatedBy             varchar(120),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for request_maintenance_seq;
	insert into dbo.request_maintenance
		(id,
		 entity ,
         entity_id ,
         tab,
         message,
         is_resolved,
         [_created_by],
         [_updated_by])
	values 
		(@id,
		 @entity				,
         @entityId,
         @tab,
         @message,
         @isResolved,
         @createdBy,
         @updatedBy)
END;
GO

