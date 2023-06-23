CREATE TABLE [staging].[contact_types] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[contact_types]
    ADD CONSTRAINT [UQ__contact___72E12F1B5AE179C7] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[contact_types]
    ADD CONSTRAINT [PK__contact___3213E83FC10EE43B] PRIMARY KEY CLUSTERED ([id] ASC);
GO

