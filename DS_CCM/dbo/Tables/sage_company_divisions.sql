CREATE TABLE [dbo].[sage_company_divisions] (
    [id]                 INT                                         NOT NULL,
    [sage_company]       VARCHAR (3)                                 NOT NULL,
    [sage_division_id]   VARCHAR (2)                                 NOT NULL,
    [name]               VARCHAR (120)                               NULL,
    [description]        VARCHAR (1024)                              NULL,
    [sort]               INT                                         NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[sage_company_divisions], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[sage_company_divisions]
    ADD CONSTRAINT [pk_sage_company_divisions] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[sage_company_divisions]
    ADD CONSTRAINT [fk_sage_company_divisions_sage_companies] FOREIGN KEY ([sage_company]) REFERENCES [dbo].[sage_companies] ([id]);
GO

ALTER TABLE [dbo].[sage_company_divisions]
    ADD CONSTRAINT [unq_sage_company_divisions] UNIQUE NONCLUSTERED ([sage_company] ASC, [sage_division_id] ASC);
GO

