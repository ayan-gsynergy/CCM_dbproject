CREATE TABLE [staging].[other_attributes] (
    [id]             INT            NOT NULL,
    [name]           VARCHAR (120)  NOT NULL,
    [description]    VARCHAR (1024) NULL,
    [data_type]      VARCHAR (20)   NOT NULL,
    [sort]           INT            NULL,
    [process_status] CHAR (1)       DEFAULT ('N') NULL,
    [error_message]  VARCHAR (300)  NULL
);
GO

ALTER TABLE [staging].[other_attributes]
    ADD CONSTRAINT [Cns_other_attributes] CHECK ([data_type]='ff' OR [data_type]='lov' OR [data_type]='bool');
GO

ALTER TABLE [staging].[other_attributes]
    ADD CONSTRAINT [UQ__other_at__72E12F1B64F0D853] UNIQUE NONCLUSTERED ([name] ASC);
GO

ALTER TABLE [staging].[other_attributes]
    ADD CONSTRAINT [PK__other_at__3213E83F7D934F80] PRIMARY KEY CLUSTERED ([id] ASC);
GO

