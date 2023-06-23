CREATE TABLE [staging].[contact_type_levels] (
    [contact_type]       INT           NOT NULL,
    [contact_type_level] VARCHAR (20)  NOT NULL,
    [process_status]     CHAR (1)      DEFAULT ('N') NULL,
    [error_message]      VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[contact_type_levels]
    ADD CONSTRAINT [PK_ContactType_ContactTypeLvl] PRIMARY KEY CLUSTERED ([contact_type] ASC, [contact_type_level] ASC);
GO

