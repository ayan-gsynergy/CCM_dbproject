CREATE TABLE [staging].[sales_person] (
    [id]             INT           NOT NULL,
    [name]           VARCHAR (120) NOT NULL,
    [process_status] CHAR (1)      DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[sales_person]
    ADD CONSTRAINT [pk_sales_person] PRIMARY KEY CLUSTERED ([id] ASC);
GO

