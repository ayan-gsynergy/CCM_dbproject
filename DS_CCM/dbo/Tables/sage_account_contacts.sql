CREATE TABLE [dbo].[sage_account_contacts] (
    [id]                         INT                                         NOT NULL,
    [sage_account]               INT                                         NULL,
    [contact]                    INT                                         NULL,
    [sage_contact_code]          VARCHAR (24)                                NULL,
    [_valid_from]                DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [sage_status]                VARCHAR (10)                                NULL,
    [sage_failed_reason_message] VARCHAR (128)                               NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[sage_account_contacts], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[sage_account_contacts]
    ADD CONSTRAINT [fk_sage_account_contacts_customer_sage_accounts] FOREIGN KEY ([sage_account]) REFERENCES [dbo].[customer_sage_accounts] ([id]);
GO

ALTER TABLE [dbo].[sage_account_contacts]
    ADD CONSTRAINT [fk_sage_account_contacts_contacts] FOREIGN KEY ([contact]) REFERENCES [dbo].[contacts] ([id]);
GO

ALTER TABLE [dbo].[sage_account_contacts]
    ADD CONSTRAINT [unq_sage_account_contacts] UNIQUE NONCLUSTERED ([sage_account] ASC, [contact] ASC);
GO

ALTER TABLE [dbo].[sage_account_contacts]
    ADD CONSTRAINT [pk_sage_account_contacts] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[sage_account_contacts]
    ADD CONSTRAINT [DF_sage_account_contacts_id] DEFAULT (NEXT VALUE FOR [sage_account_contacts_seq]) FOR [id];
GO

CREATE NONCLUSTERED INDEX [idx_sage_account_contacts]
    ON [dbo].[sage_account_contacts]([contact] ASC);
GO

