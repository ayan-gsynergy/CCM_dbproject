CREATE TABLE [history].[job_requests] (
    [request_id]         VARCHAR (128) NOT NULL,
    [job_type]           VARCHAR (30)  NOT NULL,
    [entity_type]        VARCHAR (40)  NOT NULL,
    [entity_id]          INT           NULL,
    [sage_api]           VARCHAR (128) NOT NULL,
    [request_body]       NTEXT         NULL,
    [callback_body]      NTEXT         NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL,
    [_created_by]        VARCHAR (120) NULL,
    [_created_by_action] CHAR (32)     NULL,
    [_created_on]        DATETIME2 (7) NULL,
    [response]           NTEXT         NULL
);


GO
EXECUTE sp_tableoption @TableNamePattern = N'[history].[job_requests]', @OptionName = N'text in row', @OptionValue = N'256';
GO

CREATE CLUSTERED INDEX [ix_job_requests1]
    ON [history].[job_requests]([_valid_to] ASC, [_valid_from] ASC);
GO

