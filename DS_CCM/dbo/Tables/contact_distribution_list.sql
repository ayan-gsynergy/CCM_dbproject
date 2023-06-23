CREATE TABLE [dbo].[contact_distribution_list] (
    [id]                 INT                                         NOT NULL,
    [contact]            INT                                         NOT NULL,
    [distribution_list]  INT                                         NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[contact_distribution_list], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[contact_distribution_list]
    ADD CONSTRAINT [unq_contact_distribution_list] UNIQUE NONCLUSTERED ([contact] ASC, [distribution_list] ASC);
GO

ALTER TABLE [dbo].[contact_distribution_list]
    ADD CONSTRAINT [pk_contact_distribution_list] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[contact_distribution_list]
    ADD CONSTRAINT [fk_contact_distribution_list_distribution_lists] FOREIGN KEY ([distribution_list]) REFERENCES [dbo].[distribution_lists] ([id]);
GO

ALTER TABLE [dbo].[contact_distribution_list]
    ADD CONSTRAINT [fk_contact_distribution_list_contacts] FOREIGN KEY ([contact]) REFERENCES [dbo].[contacts] ([id]);
GO

