CREATE TABLE [staging].[parent_partnerships] (
    [parent_id]      INT           NOT NULL,
    [partnerships]   INT           NOT NULL,
    [is_subscribed]  CHAR (1)      NOT NULL,
    [process_status] CHAR (1)      DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[parent_partnerships]
    ADD CONSTRAINT [PK_Parent_Partnerships] PRIMARY KEY CLUSTERED ([parent_id] ASC, [partnerships] ASC);
GO

ALTER TABLE [staging].[parent_partnerships]
    ADD CONSTRAINT [Cns_parent_partnerships] CHECK ([is_subscribed]='N' OR [is_subscribed]='Y');
GO

