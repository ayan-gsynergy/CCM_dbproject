CREATE TABLE [staging].[parent_production_types] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[parent_production_types]
    ADD CONSTRAINT [UQ__parent_p__72E12F1BCF2580EE] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[parent_production_types]
    ADD CONSTRAINT [PK__parent_p__3213E83FDB93DAF9] PRIMARY KEY CLUSTERED ([id] ASC);
GO

