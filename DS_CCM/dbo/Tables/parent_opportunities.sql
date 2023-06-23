CREATE TABLE [dbo].[parent_opportunities] (
    [id]                 INT                                         NOT NULL,
    [customer_parent]    INT                                         NOT NULL,
    [title]              VARCHAR (120)                               NOT NULL,
    [business_unit]      VARCHAR (10)                                NOT NULL,
    [priority]           INT                                         NOT NULL,
    [sales_person]       INT                                         NULL,
    [service]            INT                                         NOT NULL,
    [details]            VARCHAR (1024)                              NULL,
    [sales_process]      INT                                         NOT NULL,
    [competitors]        VARCHAR (120)                               NULL,
    [_updated_by]        VARCHAR (120)                               NOT NULL,
    [_updated_by_action] CHAR (32)                                   NOT NULL,
    [_valid_from]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [_valid_to]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [assigned_to]        VARCHAR (10)                                NULL,
    [_opened_on]         DATETIME2 (7)                               DEFAULT (getutcdate()) NOT NULL,
    [_closed_on]         DATETIME2 (7)                               NULL,
    PERIOD FOR SYSTEM_TIME ([_valid_from], [_valid_to])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[history].[parent_opportunities], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [fk_parent_opportunities_business_units] FOREIGN KEY ([business_unit]) REFERENCES [dbo].[business_units] ([id]);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [fk_parent_opportunities_sales_person] FOREIGN KEY ([sales_person]) REFERENCES [dbo].[sales_person] ([id]);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [fk_parent_opportunities_sales_processes] FOREIGN KEY ([sales_process]) REFERENCES [dbo].[opportunity_sales_processes] ([id]);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [fk_parent_opportunities_opportunity_priorities] FOREIGN KEY ([priority]) REFERENCES [dbo].[opportunity_priorities] ([id]);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [fk_parent_opportunities_business_units_0] FOREIGN KEY ([assigned_to]) REFERENCES [dbo].[business_units] ([id]);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [fk_parent_opportunities_opportunity_services] FOREIGN KEY ([service]) REFERENCES [dbo].[opportunity_services] ([id]);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [fk_parent_opportunities_customer_parents] FOREIGN KEY ([customer_parent]) REFERENCES [dbo].[customer_parents] ([id]);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [pk_parent_opportunities] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [dbo].[parent_opportunities]
    ADD CONSTRAINT [unq_parent_opportunities] UNIQUE NONCLUSTERED ([customer_parent] ASC, [title] ASC);
GO

CREATE trigger OpportunityClosing
on dbo.parent_opportunities
after insert, update as
update dbo.parent_opportunities set _closed_on = (select case when osp.opportunity_status = 'Closed' then getutcdate() end from inserted 
	join dbo.opportunity_sales_processes osp on inserted.sales_process= osp.id where
inserted.id  = parent_opportunities.id)
where id in (select id from inserted);
GO

