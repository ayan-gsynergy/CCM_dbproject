CREATE TABLE [history].[customer_sage_acc_locations] (
    [id]                         INT           NOT NULL,
    [customer_sage_account]      INT           NOT NULL,
    [location]                   INT           NOT NULL,
    [is_active]                  BIT           NOT NULL,
    [_updated_by]                VARCHAR (120) NOT NULL,
    [_updated_by_action]         CHAR (32)     NOT NULL,
    [_valid_from]                DATETIME2 (7) NOT NULL,
    [_valid_to]                  DATETIME2 (7) NOT NULL,
    [sage_ship_to_code]          VARCHAR (24)  NULL,
    [sage_status]                VARCHAR (10)  NULL,
    [sage_failed_reason_message] VARCHAR (128) NULL
);
GO

CREATE CLUSTERED INDEX [ix_customer_sage_acc_locations]
    ON [history].[customer_sage_acc_locations]([_valid_to] ASC, [_valid_from] ASC);
GO

