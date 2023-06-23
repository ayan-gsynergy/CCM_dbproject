CREATE TABLE [dbo].[locations] (
    [id]                        INT                                         NOT NULL,
    [name]                      VARCHAR (120)                               NOT NULL,
    [site_size]                 INT                                         NULL,
    [type]                      INT                                         NOT NULL,
    [premise_id]                VARCHAR (30)                                NULL,
    [is_active]                 BIT                                         DEFAULT ((1)) NOT NULL,
    [ddbt]                      VARCHAR (50)                                NULL,
    [desired_head_count]        INT                                         NULL,
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
    [phone]                     VARCHAR (20)                                NULL,
    [phone_ext]                 VARCHAR (10)                                NULL,
    [email]                     VARCHAR (120)                               NULL,
    [_updated_by]               VARCHAR (120)                               NOT NULL,
    [_updated_by_action]        CHAR (32)                                   NOT NULL,
    [_valid_from]               DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]                 DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [_created_on]               DATETIME2 (7)                               DEFAULT (getutcdate()) NOT NULL,
    [_created_by]               VARCHAR (120)                               NOT NULL,
    [pm_site_code]              VARCHAR (20)                                NULL,
    [receives_offsite_gilts]    BIT                                         DEFAULT ((0)) NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[locations], DATA_CONSISTENCY_CHECK=ON));
GO

CREATE FULLTEXT INDEX ON [dbo].[locations]
    ([name] LANGUAGE 1033, [line_1] LANGUAGE 1033, [line_2] LANGUAGE 1033, [line_3] LANGUAGE 1033, [city] LANGUAGE 1033, [state] LANGUAGE 1033, [zip] LANGUAGE 1033, [po_box_number] LANGUAGE 1033, [verified_line_1] LANGUAGE 1033, [verified_line_2] LANGUAGE 1033, [verified_line_3] LANGUAGE 1033, [verified_city] LANGUAGE 1033, [verified_state] LANGUAGE 1033, [verified_zip] LANGUAGE 1033, [verified_po_box_number] LANGUAGE 1033, [phone] LANGUAGE 1033, [email] LANGUAGE 1033)
    KEY INDEX [pk_location]
    ON [DS_CCM];
GO

ALTER TABLE [dbo].[locations]
    ADD CONSTRAINT [unq_location_0] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [dbo].[locations]
    ADD CONSTRAINT [pk_location] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[locations]
    ADD CONSTRAINT [fk_locations_location_type] FOREIGN KEY ([type]) REFERENCES [dbo].[location_types] ([id]);
GO

