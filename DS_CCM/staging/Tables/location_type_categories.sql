CREATE TABLE [staging].[location_type_categories] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[location_type_categories]
    ADD CONSTRAINT [UQ__location__72E12F1B0568ADE1] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[location_type_categories]
    ADD CONSTRAINT [PK__location__3213E83F115ACEC2] PRIMARY KEY CLUSTERED ([id] ASC);
GO

