CREATE TABLE [staging].[location_types] (
    [id]                     INT            NOT NULL,
    [name]                   VARCHAR (120)  NOT NULL,
    [description]            VARCHAR (1024) NULL,
    [location_type_category] INT            NOT NULL,
    [sort]                   INT            NULL,
    [process_status]         CHAR (1)       DEFAULT ('N') NULL,
    [error_message]          VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[location_types]
    ADD CONSTRAINT [PK__location__3213E83F0B77CE66] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[location_types]
    ADD CONSTRAINT [UQ__location__72E12F1BE634D9CB] UNIQUE NONCLUSTERED ([name] ASC);
GO

