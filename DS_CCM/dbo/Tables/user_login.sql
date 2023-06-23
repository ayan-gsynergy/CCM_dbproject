CREATE TABLE [dbo].[user_login] (
    [id]             VARCHAR (120)                               NOT NULL,
    [name]           VARCHAR (120)                               NOT NULL,
    [groups]         VARCHAR (1024)                              NULL,
    [last_logged_in] DATETIME2 (7)                               NULL,
    [_valid_from]    DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]      DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[user_login], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[user_login]
    ADD CONSTRAINT [pk_user_login] PRIMARY KEY CLUSTERED ([id] ASC);
GO

