CREATE TABLE [dbo].[parent_attributes_other_values_list] (
    [id]                 INT                                         NOT NULL,
    [attribute]          INT                                         NOT NULL,
    [value_id]           INT                                         NOT NULL,
    [value_name]         VARCHAR (120)                               NOT NULL,
    [value_description]  VARCHAR (1024)                              NULL,
    [sort]               INT                                         NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[parent_attributes_other_values_list], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[parent_attributes_other_values_list]
    ADD CONSTRAINT [pk_parent_attributes_other_values_list] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_list]
    ADD CONSTRAINT [unq_parent_attributes_other_values_list_value_id] UNIQUE NONCLUSTERED ([attribute] ASC, [value_id] ASC);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_list]
    ADD CONSTRAINT [unq_parent_attributes_other_values_list_value_name] UNIQUE NONCLUSTERED ([attribute] ASC, [value_name] ASC);
GO

ALTER TABLE [dbo].[parent_attributes_other_values_list]
    ADD CONSTRAINT [fk_parent_attributes_other_values_list_parent_attributes_other] FOREIGN KEY ([attribute]) REFERENCES [dbo].[parent_attributes_other] ([id]);
GO

