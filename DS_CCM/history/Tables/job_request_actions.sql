CREATE TABLE [history].[job_request_actions] (
    [request_id]            VARCHAR (128) NOT NULL,
    [parent]                INT           NULL,
    [billing_account]       INT           NULL,
    [sage_company_division] INT           NULL,
    [sage_account]          INT           NULL,
    [person]                INT           NULL,
    [contact]               INT           NULL,
    [location]              INT           NULL,
    [sage_account_location] INT           NULL,
    [status]                VARCHAR (10)  NULL,
    [failed_reason_code]    VARCHAR (50)  NULL,
    [failed_reason_message] VARCHAR (128) NULL,
    [ccm_id]                INT           NOT NULL,
    [_valid_from]           DATETIME2 (7) NOT NULL,
    [_valid_to]             DATETIME2 (7) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_job_request_actions]
    ON [history].[job_request_actions]([_valid_to] ASC, [_valid_from] ASC);
GO

