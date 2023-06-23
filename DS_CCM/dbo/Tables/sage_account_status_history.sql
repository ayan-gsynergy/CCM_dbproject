CREATE TABLE [dbo].[sage_account_status_history] (
    [customer_sage_account] INT           NOT NULL,
    [account_status]        INT           NULL,
    [status_changed_on]     DATETIME2 (7) NULL
);
GO

ALTER TABLE [dbo].[sage_account_status_history]
    ADD CONSTRAINT [fk_sage_account_status_history_customer_sage_accounts] FOREIGN KEY ([customer_sage_account]) REFERENCES [dbo].[customer_sage_accounts] ([id]) ON DELETE CASCADE;
GO

