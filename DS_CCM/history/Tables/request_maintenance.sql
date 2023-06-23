CREATE TABLE [history].[request_maintenance] (
    [id]          INT            NOT NULL,
    [entity]      VARCHAR (30)   NOT NULL,
    [entity_id]   INT            NOT NULL,
    [tab]         VARCHAR (30)   NOT NULL,
    [message]     VARCHAR (1024) NOT NULL,
    [is_resolved] BIT            NOT NULL,
    [_created_by] VARCHAR (120)  NOT NULL,
    [_updated_by] VARCHAR (120)  NOT NULL,
    [_created_on] DATETIME2 (7)  NOT NULL,
    [_valid_from] DATETIME2 (7)  NOT NULL,
    [_valid_to]   DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_request_maintenance]
    ON [history].[request_maintenance]([_valid_to] ASC, [_valid_from] ASC);
GO

