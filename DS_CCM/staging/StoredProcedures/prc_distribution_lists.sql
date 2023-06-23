CREATE proc [staging].[prc_distribution_lists](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, description, sort FROM [staging].[distribution_lists] WHERE process_status = 'N';
	DECLARE @id int, @name varchar (120), @description varchar (1024), @sort int;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name, @description, @sort;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.distribution_lists where id = @id)
							UPDATE [dbo].[distribution_lists] SET name = @name, description = @description, sort = @sort, _updated_by = @updated_by, _updated_by_action = @updated_by_action where id = @id;
						ELSE
							INSERT INTO [dbo].[distribution_lists] (id, name, description, sort, _updated_by, _updated_by_action) values (@id, @name, @description, @sort, @updated_by, @updated_by_action);						
						UPDATE staging.distribution_lists set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%unq%')
					UPDATE staging.distribution_lists set process_status = 'E', error_message = 'Name already exists for a different ID' where id = @id;
				ELSE
					UPDATE staging.distribution_lists set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.distribution_lists where process_status <> 'C')
END;
GO

