CREATE TABLE [history].[user_login] (
    [id]             VARCHAR (120)  NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [groups]         VARCHAR (1024) NULL,
    [last_logged_in] DATETIME2 (7)  NULL,
    [_valid_from]    DATETIME2 (7)  NOT NULL,
    [_valid_to]      DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_user_login]
    ON [history].[user_login]([_valid_to] ASC, [_valid_from] ASC);
GO

