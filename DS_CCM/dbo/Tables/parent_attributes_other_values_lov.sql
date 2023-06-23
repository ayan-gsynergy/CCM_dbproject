CREATE TABLE [dbo].[parent_attributes_other_values_lov] (
    [id]                 INT                                         NOT NULL,
    [parent]             INT                                         NOT NULL,
    [attribute_value]    INT                                         NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[parent_attributes_other_values_lov], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[parent_attributes_other_values_lov]
    ADD CONSTRAINT [pk_parent_attributes_other_values_lov] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_lov]
    ADD CONSTRAINT [unq_parent_attributes_other_values_lov] UNIQUE NONCLUSTERED ([parent] ASC, [attribute_value] ASC);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_lov]
    ADD CONSTRAINT [fk_parent_attributes_other_values_lov_customer_parents] FOREIGN KEY ([parent]) REFERENCES [dbo].[customer_parents] ([id]);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_lov]
    ADD CONSTRAINT [fk_parent_attributes_other_values_lov_parent_attributes_other_values_list] FOREIGN KEY ([attribute_value]) REFERENCES [dbo].[parent_attributes_other_values_list] ([id]);
GO

