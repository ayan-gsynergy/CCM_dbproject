CREATE TABLE [history].[contact_type_levels] (
    [id]                 INT           NOT NULL,
    [contact_type]       INT           NOT NULL,
    [contact_type_level] VARCHAR (120) NOT NULL,
    [_updated_by]        VARCHAR (120) NOT NULL,
    [_updated_by_action] CHAR (32)     NOT NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_contact_type_levels]
    ON [history].[contact_type_levels]([_valid_to] ASC, [_valid_from] ASC);
GO

