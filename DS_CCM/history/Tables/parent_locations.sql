CREATE TABLE [history].[parent_locations] (
    [id]                 INT           NOT NULL,
    [parent]             INT           NOT NULL,
    [location]           INT           NOT NULL,
    [is_active]          BIT           NOT NULL,
    [_updated_by]        VARCHAR (120) NOT NULL,
    [_updated_by_action] CHAR (32)     NOT NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_parent_locations]
    ON [history].[parent_locations]([_valid_to] ASC, [_valid_from] ASC);
GO

