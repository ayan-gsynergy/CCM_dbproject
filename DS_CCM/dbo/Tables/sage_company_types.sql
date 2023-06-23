CREATE TABLE [dbo].[sage_company_types] (
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
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[sage_company_types], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[sage_company_types]
    ADD CONSTRAINT [pk_sage_company_types] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[sage_company_types]
    ADD CONSTRAINT [unq_sage_company_types] UNIQUE NONCLUSTERED ([name] ASC);
GO

