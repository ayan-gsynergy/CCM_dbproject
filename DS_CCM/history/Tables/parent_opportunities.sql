CREATE TABLE [history].[parent_opportunities] (
    [id]                 INT            NOT NULL,
    [customer_parent]    INT            NOT NULL,
    [title]              VARCHAR (120)  NOT NULL,
    [business_unit]      VARCHAR (10)   NOT NULL,
    [priority]           INT            NOT NULL,
    [sales_person]       INT            NULL,
    [service]            INT            NOT NULL,
    [details]            VARCHAR (1024) NULL,
    [sales_process]      INT            NOT NULL,
    [competitors]        VARCHAR (120)  NULL,
    [_updated_by]        VARCHAR (120)  NOT NULL,
    [_updated_by_action] CHAR (32)      NOT NULL,
    [_valid_from]        DATETIME2 (7)  NOT NULL,
    [_valid_to]          DATETIME2 (7)  NOT NULL,
    [assigned_to]        VARCHAR (10)   NULL,
    [_opened_on]         DATETIME2 (7)  NOT NULL,
    [_closed_on]         DATETIME2 (7)  NULL
);
GO

CREATE CLUSTERED INDEX [ix_parent_opportunities]
    ON [history].[parent_opportunities]([_valid_to] ASC, [_valid_from] ASC);
GO

