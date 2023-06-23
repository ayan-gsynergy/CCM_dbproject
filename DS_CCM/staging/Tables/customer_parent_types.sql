CREATE TABLE [staging].[customer_parent_types] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[customer_parent_types]
    ADD CONSTRAINT [PK__customer__3213E83F630AF205] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[customer_parent_types]
    ADD CONSTRAINT [UQ__customer__72E12F1B459687C0] UNIQUE NONCLUSTERED ([name] ASC);
GO

