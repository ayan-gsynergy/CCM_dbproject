CREATE TABLE [staging].[opportunity_sales_processes] (
    [id]                 INT            NOT NULL,
    [name]               VARCHAR (120)  NOT NULL,
    [description]        VARCHAR (1024) NULL,
    [sort]               INT            NULL,
    [opportunity_status] VARCHAR (30)   NULL,
    [process_status]     CHAR (1)       DEFAULT ('N') NULL,
    [error_message]      VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[opportunity_sales_processes]
    ADD CONSTRAINT [Cns_opportunity_sales_processes] CHECK ([opportunity_status]='In Progress' OR [opportunity_status]='Closed');
GO

ALTER TABLE [staging].[opportunity_sales_processes]
    ADD CONSTRAINT [PK__opportun__3213E83F5B08A1BD] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [staging].[opportunity_sales_processes]
    ADD CONSTRAINT [UQ__opportun__72E12F1B5CB1515E] UNIQUE NONCLUSTERED ([name] ASC);
GO

