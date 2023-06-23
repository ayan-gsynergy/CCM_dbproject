CREATE TABLE [dbo].[opportunity_sales_processes] (
    [id]                 INT                                         NOT NULL,
    [name]               VARCHAR (120)                               NOT NULL,
    [description]        VARCHAR (1024)                              NULL,
    [sort]               INT                                         NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [opportunity_status] VARCHAR (30)                                NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[opportunity_sales_processes], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[opportunity_sales_processes]
    ADD CONSTRAINT [unq_sales_process] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [dbo].[opportunity_sales_processes]
    ADD CONSTRAINT [pk_sales_process] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[opportunity_sales_processes]
    ADD CONSTRAINT [Cns_opportunity_sales_processes] CHECK ([opportunity_status]='In Progress' OR [opportunity_status]='Closed');
GO

