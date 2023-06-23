CREATE TABLE [staging].[parent_investments] (
    [parent_id]      INT           NOT NULL,
    [investment]     INT           NOT NULL,
    [has_investment] CHAR (1)      NOT NULL,
    [process_status] CHAR (1)      DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[parent_investments]
    ADD CONSTRAINT [PK_Parent_Investment] PRIMARY KEY CLUSTERED ([parent_id] ASC, [investment] ASC);
GO

ALTER TABLE [staging].[parent_investments]
    ADD CONSTRAINT [Cns_parent_investments] CHECK ([has_investment]='N' OR [has_investment]='Y');
GO

