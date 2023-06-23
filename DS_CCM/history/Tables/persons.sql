CREATE TABLE [history].[persons] (
    [id]                    INT           NOT NULL,
    [name_first]            VARCHAR (120) NOT NULL,
    [name_last]             VARCHAR (120) NULL,
    [name_middle]           VARCHAR (120) NULL,
    [primary_adrs_ph_email] INT           NULL,
    [_updated_by]           VARCHAR (120) NOT NULL,
    [_updated_by_action]    CHAR (32)     NOT NULL,
    [_valid_from]           DATETIME2 (7) NOT NULL,
    [_valid_to]             DATETIME2 (7) NOT NULL,
    [_created_on]           DATETIME2 (7) NOT NULL,
    [_created_by]           VARCHAR (120) NOT NULL,
    [is_internal]           BIT           NULL
);
GO

CREATE CLUSTERED INDEX [ix_persons]
    ON [history].[persons]([_valid_to] ASC, [_valid_from] ASC);
GO

