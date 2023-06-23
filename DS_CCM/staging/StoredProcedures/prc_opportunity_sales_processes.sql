
CREATE proc [staging].[prc_opportunity_sales_processes](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id, name, description, sort, opportunity_status FROM [staging].[opportunity_sales_processes] WHERE process_status = 'N';
	DECLARE @id int, @name varchar (120), @description varchar (1024), @sort int, @opportunity_status varchar(30);
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @id, @name, @description, @sort, @opportunity_status;
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.opportunity_sales_processes where id = @id)
							UPDATE [dbo].[opportunity_sales_processes] SET name = @name, description = @description, sort = @sort, opportunity_status = @opportunity_status, _updated_by = @updated_by, _updated_by_action = @updated_by_action where id = @id;
						ELSE
							INSERT INTO [dbo].[opportunity_sales_processes] (id, name, description, sort, opportunity_status, _updated_by, _updated_by_action) values (@id, @name, @description, @sort, @opportunity_status, @updated_by, @updated_by_action);						
						UPDATE staging.opportunity_sales_processes set process_status = 'C' where id = @id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"unq_sales_process"%')
					UPDATE staging.opportunity_sales_processes set process_status = 'E', error_message = 'Sales Process with the given name already exists' where id = @id;
				ELSE
					UPDATE staging.opportunity_sales_processes set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.opportunity_sales_processes where process_status <> 'C')
END;
GO

