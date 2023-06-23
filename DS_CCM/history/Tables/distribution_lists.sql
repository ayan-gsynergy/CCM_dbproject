CREATE TABLE [history].[distribution_lists] (
    [id]                 INT            NOT NULL,
    [name]               VARCHAR (120)  NULL,
    [description]        VARCHAR (1024) NULL,
    [sort]               INT            NULL,
    [_updated_by]        VARCHAR (120)  NOT NULL,
    [_updated_by_action] CHAR (32)      NOT NULL,
    [_valid_from]        DATETIME2 (7)  NOT NULL,
    [_valid_to]          DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_distribution_lists]
    ON [history].[distribution_lists]([_valid_to] ASC, [_valid_from] ASC);
GO

