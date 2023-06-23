

CREATE proc [staging].[prc_sage_companies](
@updated_by varchar(120),
@updated_by_action varchar(32)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR SELECT id,name,description,business_unit,company_type,sort FROM staging.sage_companies where process_status = 'N';
	DECLARE @id varchar(10), @name varchar(120), @description varchar(1024), @business_unit varchar(10), @company_type varchar(10), @sort int;
	OPEN CUR;
	WHILE 1=1
		BEGIN
			BEGIN TRY
				FETCH NEXT FROM cur into @id,@name,@description,@business_unit,@company_type,@sort;
				if @@fetch_status <> 0
					break
				IF exists (select 1 from dbo.sage_companies where id = @id)
					update dbo.sage_companies set name = @name, description = @description,business_unit=@business_unit,company_type=@company_type, sort = @sort,_updated_by=@updated_by, _updated_by_action=@updated_by_action;
				ELSE
					insert into dbo.sage_companies (id,name,description,business_unit,company_type,sort,_updated_by,_updated_by_action) values(@id,@name,@description,@business_unit,@company_type,@sort,@updated_by,@updated_by_action);
				UPDATE staging.sage_companies set process_status = 'C' where id = @id;
			END TRY
		
			BEGIN CATCH
				IF (ERROR_NUMBER()=547 and ERROR_MESSAGE() like '%"fk_sage_companies_business_units"%' )
					UPDATE staging.sage_companies set process_status = 'E', error_message = 'Business Unit not found' where id = @id;
				ELSE IF (ERROR_NUMBER() = 547 and ERROR_MESSAGE() like '%"fk_sage_companies_sage_company_types"%')
					UPDATE staging.sage_companies set process_status = 'E', error_message = 'Sage Company type not found' where id = @id;
				ELSE IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%''unq_sage_companies''%')
					UPDATE staging.sage_companies set process_status = 'E', error_message = 'Sage Company with the given name already exists' where id = @id;
--				ELSE IF (ERROR_NUMBER()=2627 and ERROR_MESSAGE() like '%"pk_sage_companies"%')
--					UPDATE staging.sage_companies set process_status = 'E', error_message = 'Sage Company with the given id already exists' where id = @id;
				ELSE
					UPDATE staging.sage_companies set process_status = 'E', error_message = LEFT('ERR_NUM:'+cast(ERROR_NUMBER() as varchar)+' ERR_LIN:'+cast(ERROR_LINE() as varchar)+' ERR_MSG:'+ERROR_MESSAGE(),300) where id = @id;
			END CATCH
		END
	CLOSE CUR;
	DEALLOCATE CUR;
RETURN (select count(1) from staging.sage_companies where process_status <> 'C')
END;
GO

