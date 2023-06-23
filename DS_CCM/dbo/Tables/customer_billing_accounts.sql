CREATE TABLE [dbo].[customer_billing_accounts] (
    [id]                        INT                                         NOT NULL,
    [name]                      VARCHAR (120)                               NOT NULL,
    [customer_parent]           INT                                         NOT NULL,
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
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[customer_billing_accounts], DATA_CONSISTENCY_CHECK=ON));
GO

CREATE FULLTEXT INDEX ON [dbo].[customer_billing_accounts]
    ([name] LANGUAGE 1033, [phone] LANGUAGE 1033, [email] LANGUAGE 1033, [line_1] LANGUAGE 1033, [line_2] LANGUAGE 1033, [line_3] LANGUAGE 1033, [city] LANGUAGE 1033, [state] LANGUAGE 1033, [zip] LANGUAGE 1033, [po_box_number] LANGUAGE 1033, [verified_line_1] LANGUAGE 1033, [verified_line_2] LANGUAGE 1033, [verified_line_3] LANGUAGE 1033, [verified_city] LANGUAGE 1033, [verified_state] LANGUAGE 1033, [verified_zip] LANGUAGE 1033, [verified_po_box_number] LANGUAGE 1033)
    KEY INDEX [pk_customer_billing_account]
    ON [DS_CCM];
GO

ALTER TABLE [dbo].[customer_billing_accounts]
    ADD CONSTRAINT [pk_customer_billing_account] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[customer_billing_accounts]
    ADD CONSTRAINT [fk_customer_billing_accounts_customer_parents] FOREIGN KEY ([customer_parent]) REFERENCES [dbo].[customer_parents] ([id]);
GO

ALTER TABLE [dbo].[customer_billing_accounts]
    ADD CONSTRAINT [unq_customer_billing_accounts] UNIQUE NONCLUSTERED ([customer_parent] ASC, [name] ASC);
GO

