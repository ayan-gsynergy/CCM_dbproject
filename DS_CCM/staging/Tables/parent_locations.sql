CREATE TABLE [staging].[parent_locations] (
    [parent_id]      INT           NOT NULL,
    [location_id]    INT           NOT NULL,
    [is_active]      CHAR (1)      NOT NULL,
    [process_status] CHAR (1)      DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[parent_locations]
    ADD CONSTRAINT [PK_Parent_Location] PRIMARY KEY CLUSTERED ([parent_id] ASC, [location_id] ASC);
GO

ALTER TABLE [staging].[parent_locations]
    ADD CONSTRAINT [Cns_parent_locations] CHECK ([is_active]='N' OR [is_active]='Y');
GO

