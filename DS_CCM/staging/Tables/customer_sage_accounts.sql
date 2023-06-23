CREATE TABLE [staging].[customer_sage_accounts] (
    [parent_id]             INT           NOT NULL,
    [billing_account_name]  VARCHAR (120) NOT NULL,
    [sage_company]          VARCHAR (10)  NOT NULL,
    [sage_company_division] VARCHAR (10)  NOT NULL,
    [sage_account_id]       VARCHAR (24)  NOT NULL,
    [account_status]        CHAR (1)      NOT NULL,
    [created_on]            DATETIME2 (7) DEFAULT (getutcdate()) NULL,
    [process_status]        CHAR (1)      DEFAULT ('N') NULL,
    [error_message]         VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[customer_sage_accounts]
    ADD CONSTRAINT [unq_customer_sage_accounts] UNIQUE NONCLUSTERED ([parent_id] ASC, [billing_account_name] ASC, [sage_company] ASC, [sage_company_division] ASC);
GO

ALTER TABLE [staging].[customer_sage_accounts]
    ADD CONSTRAINT [pk_customer_sage_accounts] PRIMARY KEY CLUSTERED ([sage_company] ASC, [sage_company_division] ASC, [sage_account_id] ASC);
GO

ALTER TABLE [staging].[customer_sage_accounts]
    ADD CONSTRAINT [Cns_customer_sage_accounts] CHECK ([account_status]='I' OR [account_status]='A');
GO

