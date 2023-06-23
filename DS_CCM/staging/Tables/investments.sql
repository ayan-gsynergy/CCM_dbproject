CREATE TABLE [staging].[investments] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[investments]
    ADD CONSTRAINT [UQ__investme__72E12F1B7D62A6D8] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[investments]
    ADD CONSTRAINT [PK__investme__3213E83F0C2A46AF] PRIMARY KEY CLUSTERED ([id] ASC);
GO

