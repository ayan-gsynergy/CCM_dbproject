CREATE TABLE [dbo].[customer_bill_acc_locations] (
    [id]                       INT                                         NOT NULL,
    [customer_billing_account] INT                                         NOT NULL,
    [location]                 INT                                         NOT NULL,
    [is_active]                BIT                                         DEFAULT ((1)) NOT NULL,
    [_updated_by]              VARCHAR (120)                               NOT NULL,
    [_updated_by_action]       CHAR (32)                                   NOT NULL,
    [_valid_from]              DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]                DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[customer_bill_acc_locations], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[customer_bill_acc_locations]
    ADD CONSTRAINT [fk_customer_bill_acc_locations_locations] FOREIGN KEY ([location]) REFERENCES [dbo].[locations] ([id]);
GO

ALTER TABLE [dbo].[customer_bill_acc_locations]
    ADD CONSTRAINT [fk_customer_bill_acc_locations_customer_billing_accounts] FOREIGN KEY ([customer_billing_account]) REFERENCES [dbo].[customer_billing_accounts] ([id]);
GO

ALTER TABLE [dbo].[customer_bill_acc_locations]
    ADD CONSTRAINT [pk_customer_bill_acc_locations] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE NONCLUSTERED INDEX [idx_customer_bill_acc_locations]
    ON [dbo].[customer_bill_acc_locations]([location] ASC);
GO

ALTER TABLE [dbo].[customer_bill_acc_locations]
    ADD CONSTRAINT [unq_customer_bill_acc_locations] UNIQUE NONCLUSTERED ([customer_billing_account] ASC, [location] ASC);
GO

