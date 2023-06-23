
CREATE proc [staging].[prc_sales_person](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name FROM [staging].[sales_person] WHERE process_status = 'N';
	DECLARE @id int, @name varchar (120);
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.sales_person where id = @id)
							UPDATE [dbo].[sales_person] SET name = @name, _updated_by = @updated_by, _updated_by_action = @updated_by_action where id = @id;
						ELSE
							INSERT INTO [dbo].[sales_person] (id, name, _updated_by, _updated_by_action) values (@id, @name, @updated_by, @updated_by_action);						
						UPDATE staging.sales_person set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				UPDATE staging.sales_person set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH
		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.sales_person where process_status <> 'C')
END;
GO

