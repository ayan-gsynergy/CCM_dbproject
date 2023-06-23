CREATE TABLE [dbo].[customer_sage_acc_locations] (
    [id]                         INT                                         NOT NULL,
    [customer_sage_account]      INT                                         NOT NULL,
    [location]                   INT                                         NOT NULL,
    [is_active]                  BIT                                         DEFAULT ((1)) NOT NULL,
    [_updated_by]                VARCHAR (120)                               NOT NULL,
    [_updated_by_action]         CHAR (32)                                   NOT NULL,
    [_valid_from]                DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [sage_ship_to_code]          VARCHAR (24)                                NULL,
    [sage_status]                VARCHAR (10)                                NULL,
    [sage_failed_reason_message] VARCHAR (128)                               NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[customer_sage_acc_locations], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[customer_sage_acc_locations]
    ADD CONSTRAINT [pk_customer_sage_acc_locations] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[customer_sage_acc_locations]
    ADD CONSTRAINT [fk_customer_sage_acc_locations_locations] FOREIGN KEY ([location]) REFERENCES [dbo].[locations] ([id]);
GO

ALTER TABLE [dbo].[customer_sage_acc_locations]
    ADD CONSTRAINT [fk_customer_sage_acc_locations_customer_sage_accounts] FOREIGN KEY ([customer_sage_account]) REFERENCES [dbo].[customer_sage_accounts] ([id]);
GO

CREATE NONCLUSTERED INDEX [idx_customer_sage_acc_locations]
    ON [dbo].[customer_sage_acc_locations]([location] ASC);
GO

ALTER TABLE [dbo].[customer_sage_acc_locations]
    ADD CONSTRAINT [unq_customer_sage_acc_locations] UNIQUE NONCLUSTERED ([customer_sage_account] ASC, [location] ASC);
GO

