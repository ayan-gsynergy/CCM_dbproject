CREATE TABLE [staging].[distribution_lists] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[distribution_lists]
    ADD CONSTRAINT [UQ__distribu__72E12F1BB8E53130] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[distribution_lists]
    ADD CONSTRAINT [PK__distribu__3213E83F84298AF5] PRIMARY KEY CLUSTERED ([id] ASC);
GO

