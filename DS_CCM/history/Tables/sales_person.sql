CREATE TABLE [history].[sales_person] (
    [id]                 INT           NOT NULL,
    [name]               VARCHAR (120) NOT NULL,
    [_updated_by]        VARCHAR (120) NOT NULL,
    [_updated_by_action] CHAR (32)     NOT NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_sales_person]
    ON [history].[sales_person]([_valid_to] ASC, [_valid_from] ASC);
GO

