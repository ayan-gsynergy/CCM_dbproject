CREATE TABLE [history].[sage_companies] (
    [id]                 VARCHAR (3)    NOT NULL,
    [name]               VARCHAR (120)  NOT NULL,
    [description]        VARCHAR (1024) NULL,
    [business_unit]      VARCHAR (10)   NOT NULL,
    [company_type]       VARCHAR (10)   NOT NULL,
    [sort]               INT            NULL,
    [_updated_by]        VARCHAR (120)  NOT NULL,
    [_updated_by_action] CHAR (32)      NOT NULL,
    [_valid_from]        DATETIME2 (7)  NOT NULL,
    [_valid_to]          DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_sage_companies]
    ON [history].[sage_companies]([_valid_to] ASC, [_valid_from] ASC);
GO

