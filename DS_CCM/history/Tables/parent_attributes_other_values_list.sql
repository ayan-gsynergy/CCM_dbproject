CREATE TABLE [history].[parent_attributes_other_values_list] (
    [id]                 INT            NOT NULL,
    [attribute]          INT            NOT NULL,
    [value_id]           INT            NOT NULL,
    [value_name]         VARCHAR (120)  NOT NULL,
    [value_description]  VARCHAR (1024) NULL,
    [sort]               INT            NULL,
    [_updated_by]        VARCHAR (120)  NOT NULL,
    [_updated_by_action] CHAR (32)      NOT NULL,
    [_valid_from]        DATETIME2 (7)  NOT NULL,
    [_valid_to]          DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_parent_attributes_other_values_list]
    ON [history].[parent_attributes_other_values_list]([_valid_to] ASC, [_valid_from] ASC);
GO

