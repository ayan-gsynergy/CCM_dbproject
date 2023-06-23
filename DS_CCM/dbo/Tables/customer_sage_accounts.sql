CREATE TABLE [dbo].[customer_sage_accounts] (
    [id]                         INT                                         NOT NULL,
    [customer_billing_account]   INT                                         NOT NULL,
    [sage_company_division]      INT                                         NOT NULL,
    [sage_account_id]            VARCHAR (24)                                NULL,
    [account_status]             INT                                         DEFAULT ((1)) NOT NULL,
    [_updated_by]                VARCHAR (120)                               NOT NULL,
    [_updated_by_action]         CHAR (32)                                   NOT NULL,
    [_valid_from]                DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [_created_by]                VARCHAR (120)                               NOT NULL,
    [_created_on]                DATETIME2 (7)                               DEFAULT (getutcdate()) NOT NULL,
    [sage_status]                VARCHAR (10)                                NULL,
    [sage_failed_reason_message] VARCHAR (128)                               NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[customer_sage_accounts], DATA_CONSISTENCY_CHECK=ON));
GO

CREATE trigger dbo.SageAccountStatusChange
on dbo.customer_sage_accounts
after insert, update as
insert into sage_account_status_history select i.id,i.account_status,i._valid_from from inserted i
where not exists (select 1 from deleted d where i.id = d.id and i.account_status=d.account_status)
;
GO

ALTER TABLE [dbo].[customer_sage_accounts]
    ADD CONSTRAINT [unq_customer_sage_account_0] UNIQUE NONCLUSTERED ([customer_billing_account] ASC, [sage_company_division] ASC);
GO

ALTER TABLE [dbo].[customer_sage_accounts]
    ADD CONSTRAINT [fk_customer_sage_accounts_customer_account_statuses] FOREIGN KEY ([account_status]) REFERENCES [dbo].[customer_account_statuses] ([id]);
GO

ALTER TABLE [dbo].[customer_sage_accounts]
    ADD CONSTRAINT [fk_customer_sage_accounts_sage_company_divisions] FOREIGN KEY ([sage_company_division]) REFERENCES [dbo].[sage_company_divisions] ([id]);
GO

ALTER TABLE [dbo].[customer_sage_accounts]
    ADD CONSTRAINT [fk_customer_sage_accounts_customer_billing_accounts] FOREIGN KEY ([customer_billing_account]) REFERENCES [dbo].[customer_billing_accounts] ([id]);
GO

CREATE UNIQUE NONCLUSTERED INDEX [unq_customer_sage_account]
    ON [dbo].[customer_sage_accounts]([sage_company_division] ASC, [sage_account_id] ASC) WHERE ([sage_account_id] IS NOT NULL);
GO

ALTER TABLE [dbo].[customer_sage_accounts]
    ADD CONSTRAINT [pk_customer_sage_account] PRIMARY KEY CLUSTERED ([id] ASC);
GO

