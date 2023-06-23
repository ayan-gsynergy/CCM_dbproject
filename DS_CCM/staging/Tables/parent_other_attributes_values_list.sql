CREATE TABLE [staging].[parent_other_attributes_values_list] (
    [attribute]         INT            NOT NULL,
    [value_id]          INT            NOT NULL,
    [value_name]        VARCHAR (120)  NOT NULL,
    [value_description] VARCHAR (1024) NULL,
    [value_sort]        INT            NULL,
    [process_status]    CHAR (1)       DEFAULT ('N') NULL,
    [error_message]     VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[parent_other_attributes_values_list]
    ADD CONSTRAINT [unq_parent_other_attributes_values_list] UNIQUE NONCLUSTERED ([attribute] ASC, [value_name] ASC);
GO

ALTER TABLE [staging].[parent_other_attributes_values_list]
    ADD CONSTRAINT [PK_Attribute_Value] PRIMARY KEY CLUSTERED ([attribute] ASC, [value_id] ASC);
GO

