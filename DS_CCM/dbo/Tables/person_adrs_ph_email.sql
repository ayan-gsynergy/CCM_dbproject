CREATE TABLE [dbo].[person_adrs_ph_email] (
    [id]                        INT                                         NOT NULL,
    [person]                    INT                                         NOT NULL,
    [type]                      VARCHAR (120)                               NOT NULL,
    [phone]                     VARCHAR (20)                                NULL,
    [phone_ext]                 VARCHAR (10)                                NULL,
    [email]                     VARCHAR (120)                               NULL,
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
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[person_adrs_ph_email], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[person_adrs_ph_email]
    ADD CONSTRAINT [fk_person_adrs_ph_email_persons] FOREIGN KEY ([person]) REFERENCES [dbo].[persons] ([id]);
GO

CREATE FULLTEXT INDEX ON [dbo].[person_adrs_ph_email]
    ([phone] LANGUAGE 1033, [email] LANGUAGE 1033, [line_1] LANGUAGE 1033, [line_2] LANGUAGE 1033, [line_3] LANGUAGE 1033, [city] LANGUAGE 1033, [state] LANGUAGE 1033, [zip] LANGUAGE 1033, [po_box_number] LANGUAGE 1033, [verified_line_1] LANGUAGE 1033, [verified_line_2] LANGUAGE 1033, [verified_line_3] LANGUAGE 1033, [verified_city] LANGUAGE 1033, [verified_state] LANGUAGE 1033, [verified_zip] LANGUAGE 1033, [verified_po_box_number] LANGUAGE 1033)
    KEY INDEX [pk_person_add_ph_email]
    ON [DS_CCM];
GO

ALTER TABLE [dbo].[person_adrs_ph_email]
    ADD CONSTRAINT [pk_person_add_ph_email] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[person_adrs_ph_email]
    ADD CONSTRAINT [unq_person_adrs_ph_email] UNIQUE NONCLUSTERED ([person] ASC, [type] ASC);
GO

