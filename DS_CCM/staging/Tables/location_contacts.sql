CREATE TABLE [staging].[location_contacts] (
    [location_id]       INT           NOT NULL,
    [person_id]         INT           NOT NULL,
    [contact_type]      VARCHAR (MAX) NOT NULL,
    [address_type]      VARCHAR (120) NULL,
    [distribution_list] VARCHAR (MAX) NULL,
    [process_status]    CHAR (1)      NULL,
    [error_message]     VARCHAR (300) NULL
);
GO

ALTER TABLE [staging].[location_contacts]
    ADD CONSTRAINT [PK_Location_Person] PRIMARY KEY CLUSTERED ([location_id] ASC, [person_id] ASC);
GO

ALTER TABLE [staging].[location_contacts]
    ADD CONSTRAINT [DF_Loc_Cnt_PS] DEFAULT ('N') FOR [process_status];
GO

