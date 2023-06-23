CREATE TABLE [staging].[customer_sage_acc_contacts] (
    [parent_id]             INT           NOT NULL,
    [sage_company]          VARCHAR (10)  NOT NULL,
    [sage_company_division] VARCHAR (10)  NOT NULL,
    [sage_account_id]       VARCHAR (24)  NOT NULL,
    [person_id]             INT           NOT NULL,
    [contact_type]          VARCHAR (MAX) NOT NULL,
    [address_type]          VARCHAR (120) NULL,
    [distribution_list]     VARCHAR (MAX) NULL,
    [process_status]        CHAR (1)      NULL,
    [error_message]         VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[customer_sage_acc_contacts]
    ADD CONSTRAINT [DF_Sage_Acc_Cnt_PS] DEFAULT ('N') FOR [process_status];
GO

ALTER TABLE [staging].[customer_sage_acc_contacts]
    ADD CONSTRAINT [pk_customer_sage_acc_contacts] PRIMARY KEY CLUSTERED ([sage_company] ASC, [sage_company_division] ASC, [sage_account_id] ASC, [person_id] ASC);
GO

