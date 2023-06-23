CREATE TABLE [staging].[customer_bill_acc_contacts] (
    [parent_id]            INT           NOT NULL,
    [billing_account_name] VARCHAR (120) NOT NULL,
    [person_id]            INT           NOT NULL,
    [contact_type]         VARCHAR (MAX) NOT NULL,
    [address_type]         VARCHAR (120) NULL,
    [distribution_list]    VARCHAR (MAX) NULL,
    [process_status]       CHAR (1)      NULL,
    [error_message]        VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[customer_bill_acc_contacts]
    ADD CONSTRAINT [DF_Bill_Acc_Cnt_PS] DEFAULT ('N') FOR [process_status];
GO

ALTER TABLE [staging].[customer_bill_acc_contacts]
    ADD CONSTRAINT [PK_Parent_BillingAcc_Person] PRIMARY KEY CLUSTERED ([parent_id] ASC, [billing_account_name] ASC, [person_id] ASC);
GO

