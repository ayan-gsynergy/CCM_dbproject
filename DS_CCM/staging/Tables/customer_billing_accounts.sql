CREATE TABLE [staging].[customer_billing_accounts] (
    [parent_id]       INT           NOT NULL,
    [name]            VARCHAR (120) NOT NULL,
    [attention_to]    VARCHAR (120) NULL,
    [line_1]          VARCHAR (120) NOT NULL,
    [line_2]          VARCHAR (120) NULL,
    [line_3]          VARCHAR (120) NULL,
    [city]            VARCHAR (60)  NULL,
    [state]           VARCHAR (60)  NULL,
    [country]         VARCHAR (3)   NOT NULL,
    [zip]             VARCHAR (20)  NULL,
    [po_box_number]   VARCHAR (20)  NULL,
    [phone_extension] VARCHAR (10)  NULL,
    [phone]           VARCHAR (20)  NULL,
    [email]           VARCHAR (120) NULL,
    [created_on]      DATETIME2 (7) DEFAULT (getutcdate()) NULL,
    [process_status]  CHAR (1)      DEFAULT ('N') NULL,
    [error_message]   VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[customer_billing_accounts]
    ADD CONSTRAINT [PK_Parent_Name] PRIMARY KEY CLUSTERED ([parent_id] ASC, [name] ASC);
GO

