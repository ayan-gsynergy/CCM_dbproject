CREATE PROC [dbo].[update_job_requests](
	@request_id             varchar(128),
	@callback_body          nText)
AS
BEGIN
	UPDATE job_requests  
          SET callback_body  = @callback_body
          WHERE request_id  = @request_id;
END;
GO

