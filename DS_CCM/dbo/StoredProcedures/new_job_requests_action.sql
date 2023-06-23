CREATE PROC [dbo].[new_job_requests_action](
	@request_id             varchar(128),
	@ccm_id                 int,
	@parent                 int = NULL,
	@billing_account        int = NULL,
	@sage_company_division  int = NULL,
	@sage_account           int = NULL,
	@person                 int = NULL,
	@contact                int = NULL,
	@location               int = NULL,
	@sage_account_location  int = NULL,
	@status                 varchar(10) = NULL)
AS
BEGIN
	insert into dbo.job_request_actions 
		(request_id,
		ccm_id,
         parent,
         billing_account,
         sage_company_division,
         sage_account,
         person,
         contact,
         location,
         sage_account_location,
         status)
	values 
		(@request_id,
		@ccm_id,
         @parent,
         @billing_account,
         @sage_company_division,
         @sage_account,
         @person,
         @contact,
         @location,
         @sage_account_location,
         @status)
END;
GO

