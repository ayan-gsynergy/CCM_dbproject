CREATE TABLE [dbo].[business_units] (
    [id]                 VARCHAR (10)                                NOT NULL,
    [name]               VARCHAR (120)                               NOT NULL,
    [description]        VARCHAR (1024)                              NULL,
    [sort]               INT                                         NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[business_units], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[business_units]
    ADD CONSTRAINT [unq_business_units] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [dbo].[business_units]
    ADD CONSTRAINT [pk_business_units] PRIMARY KEY CLUSTERED ([id] ASC);
GO

