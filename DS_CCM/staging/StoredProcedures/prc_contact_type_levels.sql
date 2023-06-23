CREATE proc [staging].[prc_contact_type_levels](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT contact_type, contact_type_level FROM [staging].[contact_type_levels] WHERE process_status = 'N';
	DECLARE @contact_type int, @contact_type_level varchar (20);
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @contact_type, @contact_type_level;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.contact_type_levels where contact_type = @contact_type and contact_type_level = @contact_type_level)
							UPDATE [dbo].[contact_type_levels] SET _updated_by = @updated_by, _updated_by_action = @updated_by_action  where contact_type = @contact_type and contact_type_level = @contact_type_level;
						ELSE
							INSERT INTO [dbo].[contact_type_levels] (id, contact_type, contact_type_level, _updated_by, _updated_by_action) values (next value for contact_type_levels_seq, @contact_type, @contact_type_level, @updated_by, @updated_by_action);						
						UPDATE staging.contact_type_levels set process_status = 'C' where contact_type = @contact_type and contact_type_level = @contact_type_level;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk%')
					UPDATE staging.contact_type_levels set process_status = 'E', error_message = 'Contact Type not found' where contact_type = @contact_type and contact_type_level = @contact_type_level;
				ELSE
					UPDATE staging.contact_type_levels set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where contact_type = @contact_type and contact_type_level = @contact_type_level;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.contact_type_levels where process_status <> 'C')
END;
GO

