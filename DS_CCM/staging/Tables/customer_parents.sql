CREATE TABLE [staging].[customer_parents] (
    [id]              INT           NOT NULL,
    [name]            VARCHAR (120) NOT NULL,
    [type]            INT           NULL,
    [production_type] INT           NOT NULL,
    [estimated_sows]  INT           NULL,
    [estimated_hogs]  INT           NULL,
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

ALTER TABLE [staging].[customer_parents]
    ADD CONSTRAINT [PK__customer__3213E83F6712D090] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[customer_parents]
    ADD CONSTRAINT [UQ__customer__72E12F1BAAFA894E] UNIQUE NONCLUSTERED ([name] ASC);
GO

