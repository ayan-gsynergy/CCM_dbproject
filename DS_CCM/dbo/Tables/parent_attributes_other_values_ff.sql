CREATE TABLE [dbo].[parent_attributes_other_values_ff] (
    [id]                 INT                                         NOT NULL,
    [parent]             INT                                         NOT NULL,
    [attribute]          INT                                         NOT NULL,
    [value]              VARCHAR (1024)                              NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[parent_attributes_other_values_ff], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[parent_attributes_other_values_ff]
    ADD CONSTRAINT [unq_parent_attributes_other_values_ff] UNIQUE NONCLUSTERED ([parent] ASC, [attribute] ASC);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_ff]
    ADD CONSTRAINT [fk_parent_attributes_other_values_ff_parent_attributes_other] FOREIGN KEY ([attribute]) REFERENCES [dbo].[parent_attributes_other] ([id]);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_ff]
    ADD CONSTRAINT [fk_parent_attributes_other_values_ff_customer_parents] FOREIGN KEY ([parent]) REFERENCES [dbo].[customer_parents] ([id]);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_ff]
    ADD CONSTRAINT [pk_parent_attributes_other_values_ff] PRIMARY KEY CLUSTERED ([id] ASC);
GO

