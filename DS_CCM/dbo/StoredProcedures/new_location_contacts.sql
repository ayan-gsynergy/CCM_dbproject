CREATE PROC dbo.new_location_contacts(
	@location				INT,
	@person			        INT,
	@addressType			varchar(120),
	@createdBy	        varchar(120),
	@updated_by			    varchar(120),
	@updated_by_action 	    char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for contacts_seq;
	insert into dbo.contacts 
		(id,
		 location ,
         person ,
         address_type ,
         [_created_by],
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @location				,
         @person   ,
         @addressType,
         @createdBy,
		 @updated_by		,
		 @updated_by_action )
END;
GO

