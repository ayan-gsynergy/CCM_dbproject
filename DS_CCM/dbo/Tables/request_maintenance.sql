CREATE TABLE [dbo].[request_maintenance] (
    [id]          INT                                         NOT NULL,
    [entity]      VARCHAR (30)                                NOT NULL,
    [entity_id]   INT                                         NOT NULL,
    [tab]         VARCHAR (30)                                NOT NULL,
    [message]     VARCHAR (1024)                              NOT NULL,
    [is_resolved] BIT                                         DEFAULT ((0)) NOT NULL,
    [_created_by] VARCHAR (120)                               NOT NULL,
    [_updated_by] VARCHAR (120)                               NOT NULL,
    [_created_on] DATETIME2 (7)                               DEFAULT (getutcdate()) NOT NULL,
    [_valid_from] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[request_maintenance], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[request_maintenance]
    ADD CONSTRAINT [pk_request_maintenance] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[request_maintenance]
    ADD CONSTRAINT [chk_entity] CHECK ([dbo].[req_main_entity_id_check]([entity],[entity_id])=(1));
GO

