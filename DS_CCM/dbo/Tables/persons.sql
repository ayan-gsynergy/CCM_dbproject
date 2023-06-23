CREATE TABLE [dbo].[persons] (
    [id]                    INT                                         NOT NULL,
    [name_first]            VARCHAR (120)                               NOT NULL,
    [name_last]             VARCHAR (120)                               NULL,
    [name_middle]           VARCHAR (120)                               NULL,
    [primary_adrs_ph_email] INT                                         NULL,
    [_updated_by]           VARCHAR (120)                               NOT NULL,
    [_updated_by_action]    CHAR (32)                                   NOT NULL,
    [_valid_from]           DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]             DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [_created_on]           DATETIME2 (7)                               DEFAULT (getutcdate()) NOT NULL,
    [_created_by]           VARCHAR (120)                               NOT NULL,
    [is_internal]           BIT                                         DEFAULT ((0)) NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[persons], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[persons]
    ADD CONSTRAINT [fk_persons_person_adrs_ph_email] FOREIGN KEY ([primary_adrs_ph_email]) REFERENCES [dbo].[person_adrs_ph_email] ([id]);
GO

ALTER TABLE [dbo].[persons]
    ADD CONSTRAINT [pk_person] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE FULLTEXT INDEX ON [dbo].[persons]
    ([name_first] LANGUAGE 1033, [name_last] LANGUAGE 1033, [name_middle] LANGUAGE 1033)
    KEY INDEX [pk_person]
    ON [DS_CCM];
GO

