CREATE proc [staging].[prc_sage_company_divisions](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT sage_company, sage_division_id, name, description, sort FROM [staging].[sage_company_divisions] WHERE process_status = 'N';	
	DECLARE @sage_company varchar (10), @sage_division_id varchar (10), @name varchar (120), @description varchar (1024), @sort int;	
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM CUR into @sage_company, @sage_division_id, @name, @description, @sort;	
				IF @@fetch_status <> 0
					break
				ELSE
					BEGIN
						IF exists (select 1 from dbo.sage_company_divisions where sage_company = @sage_company and sage_division_id = @sage_division_id)
							UPDATE [dbo].[sage_company_divisions] SET name = @name, description = @description, sort = @sort, _updated_by = @updated_by, _updated_by_action = @updated_by_action where sage_company = @sage_company and sage_division_id = @sage_division_id;
						ELSE
							INSERT INTO [dbo].[sage_company_divisions] (id, sage_company, sage_division_id, name, description, sort, _updated_by, _updated_by_action) values (next value for sage_company_divisions_seq, @sage_company, @sage_division_id, @name, @description, @sort, @updated_by, @updated_by_action);						
						UPDATE staging.sage_company_divisions set process_status = 'C' where sage_company = @sage_company and sage_division_id = @sage_division_id;
					END
			END TRY
		
			BEGIN CATCH
				IF (ERROR_MESSAGE() like '%fk%')
					UPDATE staging.sage_company_divisions set process_status = 'E', error_message = 'Sage Company not found' where sage_company = @sage_company and sage_division_id = @sage_division_id;
				ELSE
					UPDATE staging.sage_company_divisions set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where sage_company = @sage_company and sage_division_id = @sage_division_id;
			END CATCH

		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.sage_company_divisions where process_status <> 'C')
END;
GO

