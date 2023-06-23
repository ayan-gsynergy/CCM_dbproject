CREATE TABLE [history].[sage_account_contacts] (
    [id]                         INT           NOT NULL,
    [sage_account]               INT           NULL,
    [contact]                    INT           NULL,
    [sage_contact_code]          VARCHAR (24)  NULL,
    [_valid_from]                DATETIME2 (7) NOT NULL,
    [_valid_to]                  DATETIME2 (7) NOT NULL,
    [sage_status]                VARCHAR (10)  NULL,
    [sage_failed_reason_message] VARCHAR (128) NULL
);
GO

CREATE CLUSTERED INDEX [ix_sage_account_contacts]
    ON [history].[sage_account_contacts]([_valid_to] ASC, [_valid_from] ASC);
GO

