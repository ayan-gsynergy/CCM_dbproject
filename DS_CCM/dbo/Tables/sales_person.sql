CREATE TABLE [dbo].[sales_person] (
    [id]                 INT                                         NOT NULL,
    [name]               VARCHAR (120)                               NOT NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[sales_person], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[sales_person]
    ADD CONSTRAINT [pk_sales_person] PRIMARY KEY CLUSTERED ([id] ASC);
GO

