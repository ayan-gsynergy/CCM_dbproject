CREATE TABLE [staging].[opportunity_priorities] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[opportunity_priorities]
    ADD CONSTRAINT [PK__opportun__3213E83FB2B2677B] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[opportunity_priorities]
    ADD CONSTRAINT [UQ__opportun__72E12F1B9DA95AC5] UNIQUE NONCLUSTERED ([name] ASC);
GO

