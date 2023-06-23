CREATE TABLE [staging].[parent_services] (
    [parent_id]      INT           NOT NULL,
    [service]        INT           NOT NULL,
    [is_subscribed]  CHAR (1)      NOT NULL,
    [process_status] CHAR (1)      DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[parent_services]
    ADD CONSTRAINT [Cns_parent_services] CHECK ([is_subscribed]='N' OR [is_subscribed]='Y');
GO

ALTER TABLE [staging].[parent_services]
    ADD CONSTRAINT [PK_Parent_Service] PRIMARY KEY CLUSTERED ([parent_id] ASC, [service] ASC);
GO

