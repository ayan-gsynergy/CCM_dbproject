CREATE TABLE [history].[customer_parents] (
    [id]                        INT           NOT NULL,
    [name]                      VARCHAR (120) NOT NULL,
    [type]                      INT           NULL,
    [production_type]           INT           NULL,
    [estimated_sows]            INT           NULL,
    [estimated_hogs]            INT           NULL,
    [phone]                     VARCHAR (20)  NULL,
    [phone_ext]                 VARCHAR (10)  NULL,
    [email]                     VARCHAR (120) NULL,
    [attention_to]              VARCHAR (120) NULL,
    [line_1]                    VARCHAR (120) NULL,
    [line_2]                    VARCHAR (120) NULL,
    [line_3]                    VARCHAR (120) NULL,
    [city]                      VARCHAR (60)  NULL,
    [state]                     VARCHAR (60)  NULL,
    [country]                   VARCHAR (3)   NULL,
    [zip]                       VARCHAR (20)  NULL,
    [po_box_number]             VARCHAR (20)  NULL,
    [verified_freeform_address] VARCHAR (300) NULL,
    [verified_line_1]           VARCHAR (120) NULL,
    [verified_line_2]           VARCHAR (120) NULL,
    [verified_line_3]           VARCHAR (120) NULL,
    [verified_city]             VARCHAR (30)  NULL,
    [verified_state]            VARCHAR (30)  NULL,
    [verified_country]          VARCHAR (3)   NULL,
    [verified_zip]              VARCHAR (20)  NULL,
    [verified_po_box_number]    VARCHAR (20)  NULL,
    [hash_of_verified_address]  VARCHAR (50)  NULL,
    [geo_latitude]              VARCHAR (20)  NULL,
    [geo_longitude]             VARCHAR (20)  NULL,
    [is_using_verified]         BIT           NOT NULL,
    [_updated_by]               VARCHAR (120) NOT NULL,
    [_updated_by_action]        CHAR (32)     NOT NULL,
    [_valid_from]               DATETIME2 (7) NOT NULL,
    [_valid_to]                 DATETIME2 (7) NOT NULL,
    [_created_on]               DATETIME2 (7) NOT NULL,
    [_created_by]               VARCHAR (120) NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_customer_parents]
    ON [history].[customer_parents]([_valid_to] ASC, [_valid_from] ASC);
GO

