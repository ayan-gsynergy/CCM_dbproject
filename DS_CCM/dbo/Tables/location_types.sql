CREATE TABLE [dbo].[location_types] (
    [id]                 INT                                         NOT NULL,
    [name]               VARCHAR (120)                               NOT NULL,
    [description]        VARCHAR (1024)                              NULL,
    [category]           INT                                         NOT NULL,
    [sort]               INT                                         NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[location_types], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[location_types]
    ADD CONSTRAINT [pk_location_type] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[location_types]
    ADD CONSTRAINT [fk_location_type_location_type_category] FOREIGN KEY ([category]) REFERENCES [dbo].[location_type_categories] ([id]);
GO

ALTER TABLE [dbo].[location_types]
    ADD CONSTRAINT [unq_location_type] UNIQUE NONCLUSTERED ([name] ASC);
GO

CREATE FULLTEXT INDEX ON [dbo].[location_types]
    ([name] LANGUAGE 1033)
    KEY INDEX [pk_location_type]
    ON [DS_CCM];
GO

