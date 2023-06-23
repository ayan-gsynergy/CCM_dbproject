CREATE TABLE [staging].[locations] (
    [id]                     INT           NOT NULL,
    [name]                   VARCHAR (120) NOT NULL,
    [type]                   INT           NOT NULL,
    [premise_id]             VARCHAR (30)  NULL,
    [site_size]              INT           NULL,
    [desired_head_count]     INT           NULL,
    [ddbt]                   VARCHAR (50)  NULL,
    [line_1]                 VARCHAR (120) NOT NULL,
    [line_2]                 VARCHAR (120) NULL,
    [line_3]                 VARCHAR (120) NULL,
    [city]                   VARCHAR (60)  NULL,
    [state]                  VARCHAR (60)  NULL,
    [country]                VARCHAR (3)   NOT NULL,
    [zip]                    VARCHAR (20)  NULL,
    [po_box_number]          VARCHAR (20)  NULL,
    [phone_extension]        VARCHAR (10)  NULL,
    [phone]                  VARCHAR (20)  NULL,
    [email]                  VARCHAR (120) NULL,
    [pm_site_code]           VARCHAR (20)  NULL,
    [receives_offsite_gilts] BIT           DEFAULT ((0)) NOT NULL,
    [created_on]             DATETIME2 (7) DEFAULT (sysdatetime()) NULL,
    [process_status]         CHAR (1)      DEFAULT ('N') NULL,
    [error_message]          VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[locations]
    ADD CONSTRAINT [UQ__location__72E12F1B42203834] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[locations]
    ADD CONSTRAINT [PK__location__3213E83FCFBBE2B6] PRIMARY KEY CLUSTERED ([id] ASC);
GO

