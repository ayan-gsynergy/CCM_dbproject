CREATE TABLE [dbo].[contact_contact_types] (
    [id]                 INT                                         NOT NULL,
    [contact]            INT                                         NOT NULL,
    [contact_type]       INT                                         NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[contact_contact_types], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[contact_contact_types]
    ADD CONSTRAINT [pk_contact_contact_types] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[contact_contact_types]
    ADD CONSTRAINT [fk_contact_contact_types_contacts] FOREIGN KEY ([contact]) REFERENCES [dbo].[contacts] ([id]);
GO

ALTER TABLE [dbo].[contact_contact_types]
    ADD CONSTRAINT [fk_contact_contact_types_contact_types] FOREIGN KEY ([contact_type]) REFERENCES [dbo].[contact_types] ([id]);
GO

ALTER TABLE [dbo].[contact_contact_types]
    ADD CONSTRAINT [unq_contact_contact_types] UNIQUE NONCLUSTERED ([contact] ASC, [contact_type] ASC);
GO

