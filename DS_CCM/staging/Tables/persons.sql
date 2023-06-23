CREATE TABLE [staging].[persons] (
    [id]              INT           NOT NULL,
    [name_first]      VARCHAR (120) NOT NULL,
    [name_middle]     VARCHAR (120) NULL,
    [name_last]       VARCHAR (120) NULL,
    [is_internal]     CHAR (1)      NULL,
    [address_type]    VARCHAR (120) DEFAULT ('Initial') NOT NULL,
    [is_primary]      CHAR (1)      NULL,
    [line_1]          VARCHAR (120) NULL,
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

ALTER TABLE [staging].[persons]
    ADD CONSTRAINT [PK_Id_Address] PRIMARY KEY CLUSTERED ([id] ASC, [address_type] ASC);
GO

ALTER TABLE [staging].[persons]
    ADD CONSTRAINT [chk_persons] CHECK ([is_primary]='N' OR [is_primary]='Y');
GO

