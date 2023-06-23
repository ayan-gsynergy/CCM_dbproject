CREATE TABLE [staging].[business_units] (
    [id]             VARCHAR (6)    NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[business_units]
    ADD CONSTRAINT [PK__business__3213E83F40F3A468] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[business_units]
    ADD CONSTRAINT [UQ__business__72E12F1BFC7FAC4B] UNIQUE NONCLUSTERED ([name] ASC);
GO

