CREATE TABLE [staging].[customer_sage_acc_locations] (
    [parent_id]             INT           NOT NULL,
    [sage_company]          VARCHAR (10)  NOT NULL,
    [sage_company_division] VARCHAR (10)  NOT NULL,
    [sage_account_id]       VARCHAR (24)  NOT NULL,
    [location_id]           INT           NOT NULL,
    [sage_ship_to_code]     VARCHAR (24)  NULL,
    [is_active]             CHAR (1)      NOT NULL,
    [process_status]        CHAR (1)      DEFAULT ('N') NULL,
    [error_message]         VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[customer_sage_acc_locations]
    ADD CONSTRAINT [Cns_customer_sage_acc_locations] CHECK ([is_active]='N' OR [is_active]='Y');
GO

ALTER TABLE [staging].[customer_sage_acc_locations]
    ADD CONSTRAINT [pk_customer_sage_acc_locations] PRIMARY KEY CLUSTERED ([sage_company] ASC, [sage_company_division] ASC, [sage_account_id] ASC, [location_id] ASC);
GO

