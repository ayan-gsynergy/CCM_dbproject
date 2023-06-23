CREATE TABLE [history].[contact_contact_types] (
    [id]                 INT           NOT NULL,
    [contact]            INT           NOT NULL,
    [contact_type]       INT           NOT NULL,
    [_updated_by]        VARCHAR (120) NOT NULL,
    [_updated_by_action] CHAR (32)     NOT NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_contact_contact_types]
    ON [history].[contact_contact_types]([_valid_to] ASC, [_valid_from] ASC);
GO

