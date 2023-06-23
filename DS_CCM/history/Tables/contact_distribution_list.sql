CREATE TABLE [history].[contact_distribution_list] (
    [id]                 INT           NOT NULL,
    [contact]            INT           NOT NULL,
    [distribution_list]  INT           NOT NULL,
    [_updated_by]        VARCHAR (120) NOT NULL,
    [_updated_by_action] CHAR (32)     NOT NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_contact_distribution_list]
    ON [history].[contact_distribution_list]([_valid_to] ASC, [_valid_from] ASC);
GO

