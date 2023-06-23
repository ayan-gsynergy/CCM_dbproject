CREATE TABLE [history].[sage_company_divisions] (
    [id]                 INT            NOT NULL,
    [sage_company]       VARCHAR (3)    NOT NULL,
    [sage_division_id]   VARCHAR (2)    NOT NULL,
    [name]               VARCHAR (120)  NULL,
    [description]        VARCHAR (1024) NULL,
    [sort]               INT            NULL,
    [_updated_by]        VARCHAR (120)  NOT NULL,
    [_updated_by_action] CHAR (32)      NOT NULL,
    [_valid_from]        DATETIME2 (7)  NOT NULL,
    [_valid_to]          DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_sage_company_divisions]
    ON [history].[sage_company_divisions]([_valid_to] ASC, [_valid_from] ASC);
GO

