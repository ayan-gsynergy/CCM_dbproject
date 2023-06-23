CREATE TABLE [staging].[services_subscribed] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [business_unit]  VARCHAR (10)   NOT NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[services_subscribed]
    ADD CONSTRAINT [UQ__services__72E12F1B50E2DA60] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[services_subscribed]
    ADD CONSTRAINT [PK__services__3213E83F4AEC96B7] PRIMARY KEY CLUSTERED ([id] ASC);
GO

