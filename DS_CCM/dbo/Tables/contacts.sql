CREATE TABLE [dbo].[contacts] (
    [id]                 INT                                         NOT NULL,
    [parent]             INT                                         NULL,
    [billing_account]    INT                                         NULL,
    [sage_account]       INT                                         NULL,
    [location]           INT                                         NULL,
    [person]             INT                                         NOT NULL,
    [address_type]       VARCHAR (120)                               DEFAULT ('CCM_PRIMARY') NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [_created_on]        DATETIME2 (7)                               DEFAULT (getutcdate()) NOT NULL,
    [_created_by]        VARCHAR (120)                               NOT NULL,
    [is_active]          BIT                                         DEFAULT ((1)) NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[contacts], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[contacts]
    ADD CONSTRAINT [fk_contacts_persons] FOREIGN KEY ([person]) REFERENCES [dbo].[persons] ([id]);
GO

ALTER TABLE [dbo].[contacts]
    ADD CONSTRAINT [fk_contacts_customer_parents] FOREIGN KEY ([parent]) REFERENCES [dbo].[customer_parents] ([id]);
GO

ALTER TABLE [dbo].[contacts]
    ADD CONSTRAINT [fk_contacts_customer_billing_accounts] FOREIGN KEY ([billing_account]) REFERENCES [dbo].[customer_billing_accounts] ([id]);
GO

ALTER TABLE [dbo].[contacts]
    ADD CONSTRAINT [fk_contacts_customer_sage_accounts] FOREIGN KEY ([sage_account]) REFERENCES [dbo].[customer_sage_accounts] ([id]);
GO

ALTER TABLE [dbo].[contacts]
    ADD CONSTRAINT [fk_contacts_locations] FOREIGN KEY ([location]) REFERENCES [dbo].[locations] ([id]);
GO

ALTER TABLE [dbo].[contacts]
    ADD CONSTRAINT [unq_contacts] UNIQUE NONCLUSTERED ([parent] ASC, [billing_account] ASC, [sage_account] ASC, [location] ASC, [person] ASC);
GO

CREATE NONCLUSTERED INDEX [idx_contacts]
    ON [dbo].[contacts]([billing_account] ASC);
GO

CREATE NONCLUSTERED INDEX [idx_contacts_0]
    ON [dbo].[contacts]([sage_account] ASC);
GO

CREATE NONCLUSTERED INDEX [idx_contacts_1]
    ON [dbo].[contacts]([location] ASC);
GO

CREATE NONCLUSTERED INDEX [idx_contacts_2]
    ON [dbo].[contacts]([person] ASC);
GO

ALTER TABLE [dbo].[contacts]
    ADD CONSTRAINT [pk_contacts] PRIMARY KEY CLUSTERED ([id] ASC);
GO

