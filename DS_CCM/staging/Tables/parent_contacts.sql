CREATE TABLE [staging].[parent_contacts] (
    [parent_id]         INT           NOT NULL,
    [person_id]         INT           NOT NULL,
    [contact_type]      VARCHAR (MAX) NOT NULL,
    [address_type]      VARCHAR (120) NULL,
    [distribution_list] VARCHAR (MAX) NULL,
    [process_status]    CHAR (1)      NULL,
    [error_message]     VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[parent_contacts]
    ADD CONSTRAINT [PK_Parent_Person] PRIMARY KEY CLUSTERED ([parent_id] ASC, [person_id] ASC);
GO

ALTER TABLE [staging].[parent_contacts]
    ADD CONSTRAINT [DF_Prnt_Cnt_PS] DEFAULT ('N') FOR [process_status];
GO

