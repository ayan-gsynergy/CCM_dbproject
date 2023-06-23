CREATE PROC [dbo].[update_request_maintenance](
    @id                    INT,
	@message               varchar(1024),
	@isResolved            bit,
	@updatedBy             varchar(130))
AS
BEGIN
	UPDATE request_maintenance  
          SET message = COALESCE(@message, message),
              is_resolved = COALESCE(@isResolved, is_resolved),
              [_updated_by]  = COALESCE(@updatedBy, [_updated_by])
	WHERE id = @id;
END;
GO

