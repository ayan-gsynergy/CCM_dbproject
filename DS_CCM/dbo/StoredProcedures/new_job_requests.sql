CREATE PROC [dbo].[new_job_requests](
	@job_type				varchar(30),
	@entity_type     		varchar(40),
	@entity_id			    int,
	@sage_api               varchar(128),
	@request_id             varchar(128),
	@request_body           nText,
	@response               nText = NULL,
	@callback_body          nText = NULL,
	@created_by             varchar(120),
	@created_by_action      varchar(32))
AS
BEGIN
	insert into dbo.job_requests 
		(job_type ,
		 entity_type ,
         entity_id  ,
         sage_api,
         request_id,
         request_body,
         response,
         callback_body,
         [_created_by],
         [_created_by_action])
	values 
		(@job_type,
		 @entity_type,
         @entity_id,
         @sage_api,
         @request_id,
         @request_body,
         @response,
         @callback_body,
         @created_by,
         @created_by_action)
END;
GO

