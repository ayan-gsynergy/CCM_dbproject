CREATE TABLE [dbo].[contact_types] (
    [id]                 INT                                         NOT NULL,
    [name]               VARCHAR (120)                               NOT NULL,
    [description]        VARCHAR (1024)                              NULL,
    [sort]               INT                                         NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[contact_types], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[contact_types]
    ADD CONSTRAINT [pk_contact_type] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[contact_types]
    ADD CONSTRAINT [unq_contact_type] UNIQUE NONCLUSTERED ([name] ASC);
GO

