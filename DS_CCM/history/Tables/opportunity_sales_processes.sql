CREATE TABLE [history].[opportunity_sales_processes] (
    [id]                 INT            NOT NULL,
    [name]               VARCHAR (120)  NOT NULL,
    [description]        VARCHAR (1024) NULL,
    [sort]               INT            NULL,
    [_updated_by]        VARCHAR (120)  NOT NULL,
    [_updated_by_action] CHAR (32)      NOT NULL,
    [_valid_from]        DATETIME2 (7)  NOT NULL,
    [_valid_to]          DATETIME2 (7)  NOT NULL,
    [opportunity_status] VARCHAR (30)   NULL
);
GO

CREATE CLUSTERED INDEX [ix_opportunity_sales_processes]
    ON [history].[opportunity_sales_processes]([_valid_to] ASC, [_valid_from] ASC);
GO

