CREATE TABLE [dbo].[customer_parents] (
    [id]                        INT                                         NOT NULL,
    [name]                      VARCHAR (120)                               NOT NULL,
    [type]                      INT                                         NULL,
    [production_type]           INT                                         NULL,
    [estimated_sows]            INT                                         NULL,
    [estimated_hogs]            INT                                         NULL,
    [phone]                     VARCHAR (20)                                NULL,
    [phone_ext]                 VARCHAR (10)                                NULL,
    [email]                     VARCHAR (120)                               NULL,
    [attention_to]              VARCHAR (120)                               NULL,
    [line_1]                    VARCHAR (120)                               NULL,
    [line_2]                    VARCHAR (120)                               NULL,
    [line_3]                    VARCHAR (120)                               NULL,
    [city]                      VARCHAR (60)                                NULL,
    [state]                     VARCHAR (60)                                NULL,
    [country]                   VARCHAR (3)                                 NULL,
    [zip]                       VARCHAR (20)                                NULL,
    [po_box_number]             VARCHAR (20)                                NULL,
    [verified_freeform_address] VARCHAR (300)                               NULL,
    [verified_line_1]           VARCHAR (120)                               NULL,
    [verified_line_2]           VARCHAR (120)                               NULL,
    [verified_line_3]           VARCHAR (120)                               NULL,
    [verified_city]             VARCHAR (30)                                NULL,
    [verified_state]            VARCHAR (30)                                NULL,
    [verified_country]          VARCHAR (3)                                 NULL,
    [verified_zip]              VARCHAR (20)                                NULL,
    [verified_po_box_number]    VARCHAR (20)                                NULL,
    [hash_of_verified_address]  VARCHAR (50)                                NULL,
    [geo_latitude]              VARCHAR (20)                                NULL,
    [geo_longitude]             VARCHAR (20)                                NULL,
    [is_using_verified]         BIT                                         DEFAULT ((0)) NOT NULL,
    [_updated_by]               VARCHAR (120)                               NOT NULL,
    [_updated_by_action]        CHAR (32)                                   NOT NULL,
    [_valid_from]               DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]                 DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [_created_on]               DATETIME2 (7)                               DEFAULT (getutcdate()) NOT NULL,
    [_created_by]               VARCHAR (120)                               NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[customer_parents], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[customer_parents]
    ADD CONSTRAINT [fk_customer_parents_customer_parent_types] FOREIGN KEY ([type]) REFERENCES [dbo].[parent_types] ([id]);
GO

ALTER TABLE [dbo].[customer_parents]
    ADD CONSTRAINT [fk_customer_parents_production_types] FOREIGN KEY ([production_type]) REFERENCES [dbo].[parent_production_types] ([id]);
GO

CREATE FULLTEXT INDEX ON [dbo].[customer_parents]
    ([name] LANGUAGE 1033, [phone] LANGUAGE 1033, [email] LANGUAGE 1033, [line_1] LANGUAGE 1033, [line_2] LANGUAGE 1033, [line_3] LANGUAGE 1033, [city] LANGUAGE 1033, [state] LANGUAGE 1033, [zip] LANGUAGE 1033, [po_box_number] LANGUAGE 1033, [verified_line_1] LANGUAGE 1033, [verified_line_2] LANGUAGE 1033, [verified_line_3] LANGUAGE 1033, [verified_city] LANGUAGE 1033, [verified_state] LANGUAGE 1033, [verified_zip] LANGUAGE 1033, [verified_po_box_number] LANGUAGE 1033)
    KEY INDEX [pk_customer_parent]
    ON [DS_CCM];
GO

ALTER TABLE [dbo].[customer_parents]
    ADD CONSTRAINT [pk_customer_parent] PRIMARY KEY CLUSTERED ([id] ASC);
GO

