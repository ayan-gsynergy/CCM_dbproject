CREATE TABLE [dbo].[parent_locations] (
    [id]                 INT                                         NOT NULL,
    [parent]             INT                                         NOT NULL,
    [location]           INT                                         NOT NULL,
    [is_active]          BIT                                         DEFAULT ((1)) NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[parent_locations], DATA_CONSISTENCY_CHECK=ON));
GO

CREATE NONCLUSTERED INDEX [idx_parent_locations]
    ON [dbo].[parent_locations]([location] ASC);
GO

ALTER TABLE [dbo].[parent_locations]
    ADD CONSTRAINT [pk_customer_parent_locations] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[parent_locations]
    ADD CONSTRAINT [fk_customer_parent_locations_customer_parents] FOREIGN KEY ([parent]) REFERENCES [dbo].[customer_parents] ([id]);
GO

ALTER TABLE [dbo].[parent_locations]
    ADD CONSTRAINT [fk_customer_parent_locations_locations] FOREIGN KEY ([location]) REFERENCES [dbo].[locations] ([id]);
GO

ALTER TABLE [dbo].[parent_locations]
    ADD CONSTRAINT [unq_customer_parent_locations] UNIQUE NONCLUSTERED ([parent] ASC, [location] ASC);
GO

