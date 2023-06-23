
CREATE proc [dbo].[update_job_requests_actions_status1](
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
                    set sage_account_id = case sad.sageAcctId when '' then null else sad.sageAcctId end,
                        sage_status= jrad.status,
                        sage_failed_reason_message = jrad.failedReasonMessage,
                        _updated_by = @updated_by,
                        _updated_by_action = @updated_by_action
                    from openjson(@inp_jsn, '$.sageAccountData') 
                    with (
                            id int, 
                            sageAcctId varchar(24)
                        )sad
                    join customer_sage_accounts csa on csa.id = sad.id
                    inner hash join openjson(@inp_jsn,'$.jobRequestActionData')
					with(
							ccmId int,
							status varchar(10),
							failedReasonMessage varchar(128)
						) jrad
					on jrad.ccmId = csa.id;

				END;
            else if json_query(@inp_jsn,'$.sageContactData') is not null
                BEGIN
                    update sac 
                    set sage_contact_code = case scd.sageContactCode when '' then null else scd.sageContactCode end,
                        sage_status= jra.status,
                        sage_failed_reason_message = jra.failed_reason_message
                    from openjson(@inp_jsn, '$.sageContactData') 
                    with (
                            id int, 
                            sageContactCode varchar(24)
                        )scd
                    join sage_account_contacts sac on sac.id = scd.id
                    join job_request_actions jra on jra.request_id = @req_id and jra.ccm_id=sac.id;
                END;
            else if json_query(@inp_jsn,'$.sageLocationData') is not null
                BEGIN
                    update csal
                    set sage_ship_to_code =  case sld.sageShipToLocationCode when '' then null else sld.sageShipToLocationCode end,
                        sage_status= jra.status,
                        sage_failed_reason_message = jra.failed_reason_message,
                        _updated_by = @updated_by,
                        _updated_by_action = @updated_by_action 
                    from openjson(@inp_jsn, '$.sageLocationData') 
                    with (
                            id int, 
                            sageShipToLocationCode varchar(24)
                        )sld
                    join customer_sage_acc_locations csal on csal.id = sld.id
                    join job_request_actions jra on jra.request_id = @req_id and jra.ccm_id=csal.id;
                    
                END;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        print ERROR_MESSAGE();
    END CATCH;
END;
GO

