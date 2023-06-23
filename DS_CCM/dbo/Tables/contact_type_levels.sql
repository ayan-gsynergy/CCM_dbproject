CREATE TABLE [dbo].[contact_type_levels] (
    [id]                 INT                                         NOT NULL,
    [contact_type]       INT                                         NOT NULL,
    [contact_type_level] VARCHAR (120)                               NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[contact_type_levels], DATA_CONSISTENCY_CHECK=ON));
GO

CREATE NONCLUSTERED INDEX [idx_contact_type_levels]
    ON [dbo].[contact_type_levels]([contact_type_level] ASC);
GO

ALTER TABLE [dbo].[contact_type_levels]
    ADD CONSTRAINT [pk_contact_type_levels] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[contact_type_levels]
    ADD CONSTRAINT [unq_contact_type_levels] UNIQUE NONCLUSTERED ([contact_type] ASC, [contact_type_level] ASC);
GO

ALTER TABLE [dbo].[contact_type_levels]
    ADD CONSTRAINT [fk_contact_type_levels_contact_types] FOREIGN KEY ([contact_type]) REFERENCES [dbo].[contact_types] ([id]);
GO

