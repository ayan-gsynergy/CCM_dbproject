CREATE TABLE [staging].[sage_company_types] (
    [id]             VARCHAR (10)   NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[sage_company_types]
    ADD CONSTRAINT [UQ__sage_com__72E12F1B10033047] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[sage_company_types]
    ADD CONSTRAINT [PK__sage_com__3213E83FED0FFE55] PRIMARY KEY CLUSTERED ([id] ASC);
GO

