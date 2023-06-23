
CREATE proc [dbo].[update_job_requests_actions_status](
    @inp_jsn nvarchar(max),
    @updated_by varchar(120),
    @updated_by_action char(32))
as
BEGIN
    declare @req_id varchar(128)=json_value(@inp_jsn,'$.jobRequestActionData[0].requestId');
    BEGIN TRY
        BEGIN TRANSACTION
            update jra
            set status = jrad.status,
                failed_reason_code = jrad.failedReasonCode,
                failed_reason_message = jrad.failedReasonMessage
            from job_request_actions jra
            join openjson(@inp_jsn,'$.jobRequestActionData')
            with (
                    ccmId int,
                    status varchar(10),
                    failedReasonCode varchar(50),
                    failedReasonMessage varchar(128),
                    requestId varchar(128)
                    ) jrad
            on jrad.ccmId = jra.ccm_id
            and jrad.requestId = jra.request_id;
            if json_query(@inp_jsn,'$.sageAccountData') is not null
				BEGIN
                    update csa 
                    set sage_account_id = case isnull(sad.sageAcctId,'') when '' then csa.sage_account_id else sad.sageAcctId end,
                        sage_status= jra.status,
                        sage_failed_reason_message = jra.failed_reason_message,
                        _updated_by = @updated_by,
                        _updated_by_action = @updated_by_action
                    from (select * from job_request_actions where request_id = @req_id) jra 
					left join customer_sage_accounts csa
					on jra.ccm_id=csa.id
					left join
					openjson(@inp_jsn, '$.sageAccountData') 
                    with (
                            id int, 
                            sageAcctId varchar(24)
                        )sad
                    on sad.id = jra.ccm_id;
				END;
            else if json_query(@inp_jsn,'$.sageContactData') is not null
                BEGIN
                    update sac 
                    set sage_contact_code = case isnull(scd.sageContactCode,'') when '' then null else scd.sageContactCode end,
                        sage_status= jra.status,
                        sage_failed_reason_message = jra.failed_reason_message
                    from (select * from job_request_actions where request_id = @req_id) jra
					left join sage_account_contacts sac on sac.id = jra.ccm_id
					left join openjson(@inp_jsn, '$.sageContactData') 
                    with (
                            id int, 
                            sageContactCode varchar(24)
                        )scd
                    
                    on jra.ccm_id=scd.id;
                END;
            else if json_query(@inp_jsn,'$.sageLocationData') is not null
                BEGIN
                    update csal
                    set sage_ship_to_code =  case isnull(sld.sageShipToLocationCode,'') when '' then null else sld.sageShipToLocationCode end,
                        sage_status= jra.status,
                        sage_failed_reason_message = jra.failed_reason_message,
                        _updated_by = @updated_by,
                        _updated_by_action = @updated_by_action 
                    from (select * from job_request_actions where request_id = @req_id) jra
					left join customer_sage_acc_locations csal on csal.id = jra.ccm_id
					left join openjson(@inp_jsn, '$.sageLocationData') 
                    with (
                            id int, 
                            sageShipToLocationCode varchar(24)
                        )sld
                    on jra.ccm_id=sld.id;
                    
                END;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        print ERROR_MESSAGE();
    END CATCH;
END;
GO

