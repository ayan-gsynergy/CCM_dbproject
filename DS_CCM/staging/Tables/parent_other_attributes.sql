CREATE TABLE [staging].[parent_other_attributes] (
    [parent_id]      INT           NOT NULL,
    [attribute]      INT           NOT NULL,
    [value]          VARCHAR (120) NOT NULL,
    [process_status] CHAR (1)      DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[parent_other_attributes]
    ADD CONSTRAINT [PK_Parent_Attribute] PRIMARY KEY CLUSTERED ([parent_id] ASC, [attribute] ASC);
GO

