CREATE TABLE [staging].[customer_account_statuses] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[customer_account_statuses]
    ADD CONSTRAINT [PK__customer__3213E83F22DB9585] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[customer_account_statuses]
    ADD CONSTRAINT [UQ__customer__72E12F1BBEE2D5DE] UNIQUE NONCLUSTERED ([name] ASC);
GO

