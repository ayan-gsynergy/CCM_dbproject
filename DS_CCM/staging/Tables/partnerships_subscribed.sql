CREATE TABLE [staging].[partnerships_subscribed] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[partnerships_subscribed]
    ADD CONSTRAINT [UQ__partners__72E12F1BEB13A036] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[partnerships_subscribed]
    ADD CONSTRAINT [PK__partners__3213E83F739F93DE] PRIMARY KEY CLUSTERED ([id] ASC);
GO

