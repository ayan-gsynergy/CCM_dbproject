CREATE TABLE [dbo].[job_requests] (
    [request_id]         VARCHAR (128)                               NOT NULL,
    [job_type]           VARCHAR (30)                                NOT NULL,
    [entity_type]        VARCHAR (40)                                NOT NULL,
    [entity_id]          INT                                         NULL,
    [sage_api]           VARCHAR (128)                               NOT NULL,
    [request_body]       NTEXT                                       NULL,
    [callback_body]      NTEXT                                       NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [_created_by]        VARCHAR (120)                               NULL,
    [_created_by_action] CHAR (32)                                   NULL,
    [_created_on]        DATETIME2 (7)                               DEFAULT (getutcdate()) NULL,
    [response]           NTEXT                                       NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[job_requests], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[job_requests]
    ADD CONSTRAINT [pk_job_requests1] PRIMARY KEY CLUSTERED ([request_id] ASC);
GO

