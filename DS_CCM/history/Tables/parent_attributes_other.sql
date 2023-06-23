CREATE TABLE [history].[parent_attributes_other] (
    [id]                 INT            NOT NULL,
    [name]               VARCHAR (120)  NOT NULL,
    [description]        VARCHAR (1024) NULL,
    [data_type]          VARCHAR (10)   NOT NULL,
    [sort]               INT            NULL,
    [is_active]          BIT            NOT NULL,
    [_updated_by]        VARCHAR (120)  NOT NULL,
    [_updated_by_action] CHAR (32)      NOT NULL,
    [_valid_from]        DATETIME2 (7)  NOT NULL,
    [_valid_to]          DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_parent_attributes_other]
    ON [history].[parent_attributes_other]([_valid_to] ASC, [_valid_from] ASC);
GO

