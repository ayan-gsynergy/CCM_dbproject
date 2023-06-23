CREATE TABLE [dbo].[job_request_actions] (
    [request_id]            VARCHAR (128)                               NOT NULL,
    [parent]                INT                                         NULL,
    [billing_account]       INT                                         NULL,
    [sage_company_division] INT                                         NULL,
    [sage_account]          INT                                         NULL,
    [person]                INT                                         NULL,
    [contact]               INT                                         NULL,
    [location]              INT                                         NULL,
    [sage_account_location] INT                                         NULL,
    [status]                VARCHAR (10)                                NULL,
    [failed_reason_code]    VARCHAR (50)                                NULL,
    [failed_reason_message] VARCHAR (128)                               NULL,
    [ccm_id]                INT                                         NOT NULL,
    [_valid_from]           DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]             DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[job_request_actions], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[job_request_actions]
    ADD CONSTRAINT [fk_job_request_actions_job_requests] FOREIGN KEY ([request_id]) REFERENCES [dbo].[job_requests] ([request_id]);
GO

ALTER TABLE [dbo].[job_request_actions]
    ADD CONSTRAINT [fk_job_request_actions_sage_company_divisions] FOREIGN KEY ([sage_company_division]) REFERENCES [dbo].[sage_company_divisions] ([id]);
GO

ALTER TABLE [dbo].[job_request_actions]
    ADD CONSTRAINT [pk_job_request_actions] PRIMARY KEY CLUSTERED ([request_id] ASC, [ccm_id] ASC);
GO

