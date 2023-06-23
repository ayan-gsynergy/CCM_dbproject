CREATE TABLE [history].[contacts] (
    [id]                 INT           NOT NULL,
    [parent]             INT           NULL,
    [billing_account]    INT           NULL,
    [sage_account]       INT           NULL,
    [location]           INT           NULL,
    [person]             INT           NOT NULL,
    [address_type]       VARCHAR (120) NOT NULL,
    [_updated_by]        VARCHAR (120) NOT NULL,
    [_updated_by_action] CHAR (32)     NOT NULL,
    [_valid_from]        DATETIME2 (7) NOT NULL,
    [_valid_to]          DATETIME2 (7) NOT NULL,
    [_created_on]        DATETIME2 (7) NOT NULL,
    [_created_by]        VARCHAR (120) NOT NULL,
    [is_active]          BIT           NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_contacts]
    ON [history].[contacts]([_valid_to] ASC, [_valid_from] ASC);
GO

