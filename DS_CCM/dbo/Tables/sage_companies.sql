CREATE TABLE [dbo].[sage_companies] (
    [id]                 VARCHAR (3)                                 NOT NULL,
    [name]               VARCHAR (120)                               NOT NULL,
    [description]        VARCHAR (1024)                              NULL,
    [business_unit]      VARCHAR (10)                                NOT NULL,
    [company_type]       VARCHAR (10)                                NOT NULL,
    [sort]               INT                                         NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[sage_companies], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[sage_companies]
    ADD CONSTRAINT [fk_sage_companies_business_units] FOREIGN KEY ([business_unit]) REFERENCES [dbo].[business_units] ([id]);
GO

ALTER TABLE [dbo].[sage_companies]
    ADD CONSTRAINT [fk_sage_companies_sage_company_types] FOREIGN KEY ([company_type]) REFERENCES [dbo].[sage_company_types] ([id]);
GO

ALTER TABLE [dbo].[sage_companies]
    ADD CONSTRAINT [pk_sage_companies] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[sage_companies]
    ADD CONSTRAINT [unq_sage_companies] UNIQUE NONCLUSTERED ([name] ASC);
GO

