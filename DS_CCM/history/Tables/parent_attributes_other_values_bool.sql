CREATE TABLE [history].[parent_attributes_other_values_bool] (
    [id]                 INT           NOT NULL,
    [parent]             INT           NOT NULL,
    [attribute]          INT           NOT NULL,
    [value]              BIT           NOT NULL,
    [_updated_by]        VARCHAR (120) NOT NULL,
    [_updated_by_action] CHAR (32)     NOT NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_parent_attributes_other_values_bool]
    ON [history].[parent_attributes_other_values_bool]([_valid_to] ASC, [_valid_from] ASC);
GO

