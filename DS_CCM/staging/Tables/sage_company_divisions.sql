CREATE TABLE [staging].[sage_company_divisions] (
    [sage_company]     VARCHAR (10)   NOT NULL,
    [sage_division_id] VARCHAR (10)   NOT NULL,
    [name]             VARCHAR (120)  NOT NULL,
    [description]      VARCHAR (1024) NULL,
    [sort]             INT            NULL,
    [process_status]   CHAR (1)       DEFAULT ('N') NULL,
    [error_message]    VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[sage_company_divisions]
    ADD CONSTRAINT [PK_Company_Division] PRIMARY KEY CLUSTERED ([sage_company] ASC, [sage_division_id] ASC);
GO

