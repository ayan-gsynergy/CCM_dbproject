CREATE TABLE [dbo].[parent_attributes_services] (
    [id]                 INT                                         NOT NULL,
    [name]               VARCHAR (120)                               NOT NULL,
    [description]        VARCHAR (1024)                              NULL,
    [business_unit]      VARCHAR (10)                                NULL,
    [sort]               INT                                         NULL,
    [is_active]          BIT                                         DEFAULT ((1)) NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[parent_attributes_services], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[parent_attributes_services]
    ADD CONSTRAINT [unq_parent_attributes_services] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [dbo].[parent_attributes_services]
    ADD CONSTRAINT [fk_parent_attributes_services_business_units] FOREIGN KEY ([business_unit]) REFERENCES [dbo].[business_units] ([id]);
GO

ALTER TABLE [dbo].[parent_attributes_services]
    ADD CONSTRAINT [pk_parent_attributes_services] PRIMARY KEY CLUSTERED ([id] ASC);
GO

