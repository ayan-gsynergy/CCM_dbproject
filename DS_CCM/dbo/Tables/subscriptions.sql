CREATE TABLE [dbo].[subscriptions] (
    [id]           VARCHAR (32)  NOT NULL,
    [api_key]      VARCHAR (128) NULL,
    [callback_url] VARCHAR (MAX) NULL,
    [credentials]  VARCHAR (MAX) NULL,
    [criteria]     VARCHAR (MAX) NULL,
    [_created_on]  DATETIME2 (7) NULL
);
GO

ALTER TABLE [dbo].[subscriptions]
    ADD CONSTRAINT [pk_subscriptions] PRIMARY KEY CLUSTERED ([id] ASC);
GO

