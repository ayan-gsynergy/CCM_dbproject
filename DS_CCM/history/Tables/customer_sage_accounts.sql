CREATE TABLE [history].[customer_sage_accounts] (
    [id]                         INT           NOT NULL,
    [customer_billing_account]   INT           NOT NULL,
    [sage_company_division]      INT           NOT NULL,
    [sage_account_id]            VARCHAR (24)  NULL,
    [account_status]             INT           NOT NULL,
    [_updated_by]                VARCHAR (120) NOT NULL,
    [_updated_by_action]         CHAR (32)     NOT NULL,
    [_valid_from]                DATETIME2 (7) NOT NULL,
    [_valid_to]                  DATETIME2 (7) NOT NULL,
    [_created_by]                VARCHAR (120) NOT NULL,
    [_created_on]                DATETIME2 (7) NOT NULL,
    [sage_status]                VARCHAR (10)  NULL,
    [sage_failed_reason_message] VARCHAR (128) NULL
);
GO

CREATE CLUSTERED INDEX [ix_customer_sage_accounts]
    ON [history].[customer_sage_accounts]([_valid_to] ASC, [_valid_from] ASC);
GO

