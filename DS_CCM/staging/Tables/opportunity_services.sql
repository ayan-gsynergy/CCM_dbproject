CREATE TABLE [staging].[opportunity_services] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[opportunity_services]
    ADD CONSTRAINT [UQ__opportun__72E12F1B3D5EE353] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[opportunity_services]
    ADD CONSTRAINT [PK__opportun__3213E83F5C778661] PRIMARY KEY CLUSTERED ([id] ASC);
GO

