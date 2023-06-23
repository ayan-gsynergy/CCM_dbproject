CREATE TABLE [staging].[sage_companies] (
    [id]             VARCHAR (10)   NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [business_unit]  VARCHAR (10)   NOT NULL,
    [company_type]   VARCHAR (10)   NOT NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[sage_companies]
    ADD CONSTRAINT [PK__sage_com__3213E83F6A8A8C48] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[sage_companies]
    ADD CONSTRAINT [UQ__sage_com__72E12F1BFF6214E6] UNIQUE NONCLUSTERED ([name] ASC);
GO

