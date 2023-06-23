



create FUNCTION  [dbo].[getContactsOfParent] (@id int)  
 RETURNS NVARCHAR(MAX)  
AS  
BEGIN
	declare @json_text nvarchar(max);
	with con as(
        select c.id,c.person,isnull(c.parent,cba.customer_parent) parent_account,isnull(c.billing_account,csa.customer_billing_account) billing_account,c.sage_account,
        (select
            c.id,
            c.address_type addressType,
            null type,
            c.is_active isActive,
            concat(p.name_first,case when len(p.name_middle)>0 then ' ' end,p.name_middle,case when len(p.name_last)>0 then ' ' end ,p.name_last) as 'name',
            p.name_first firstName,
            p.name_middle middleName,
            p.name_last lastName,
            p.id personId,
            c.location locationId,
            c.parent parentId,
            c.billing_account billingAccId,
            c.sage_account sageAccId,
            null billingAccounts,
            JSON_QUERY((select '['+string_agg(contact_type,',')+']' from contact_contact_types cct where cct.contact = c.id)) contactTypes,
            JSON_QUERY((select '['+string_agg(distribution_list,',')+']' from contact_distribution_list cdl where cdl.contact = c.id )) contactDistributions,
            pape.phone as 'contact.phone',
            pape.phone_ext as 'contact.phoneExt',
            pape.email as 'contact.email',
            pape.line_1 as 'address.line1',
            pape.line_2 as 'address.line2',
            pape.line_3 as 'address.line3',
            pape.city as 'address.city',
            pape.[state] as 'address.state',
            pape.country as 'address.country',
            pape.zip as 'address.zip',
            pape.po_box_number as 'address.poBoxNo',
            pape.is_using_verified as 'address.isUsingVerified',
            pape.verified_line_1 as 'address.verified.line1',
            pape.verified_line_2 as 'address.verified.line2',
            pape.verified_line_3 as 'address.verified.line3',
            pape.verified_city as 'address.verified.city',
            pape.verified_state as 'address.verified.state',
            pape.verified_country as 'address.verified.country',
            pape.verified_zip as 'address.verified.zip',
            pape.verified_po_box_number as 'address.verified.poBoxNo',
            c.[_created_on] createdOn,
            c.[_created_by] createdBy,
            c.[_valid_from] updatedOn,
            c.[_updated_by] updatedBy,
            (select top 1 sage_contact_code from sage_account_contacts sac where sac.contact = c.id order by sage_contact_code) as sageContactCode,
            JSON_QUERY((
                select min(code) as code ,string_agg(message,', ') within group (order by message) as 'message' from(
                    select distinct sage_failed_reason_message message,min(sage_status) over() 'code' from sage_account_contacts sac where contact = c.id)a 
                for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES
            )) as 'status' for JSON PATH,INCLUDE_NULL_VALUES,WITHOUT_ARRAY_WRAPPER) as jsn
        FROM
            contacts c join persons p on p.id = c.person 
            join person_adrs_ph_email pape on (pape.person = p.id and ((c.address_type = 'CCM_PRIMARY' and pape.id= p.primary_adrs_ph_email) or pape.type = c.address_type))
            left join customer_sage_accounts csa on c.sage_account = csa.id
            left join customer_billing_accounts cba on cba.id = isnull(c.billing_account,csa.customer_billing_account)
        WHERE
            isnull(c.parent,cba.customer_parent)=@id),
        a(jsn_txt) as (
        select 
            JSON_QUERY((select '['+string_agg(jsn,',')+']' from con where (billing_account is null and sage_account is null))) contacts,
            (
                select
                    cba.id,
                    cba.name,
                    cba.customer_parent parentID,
                    cba.phone as 'contact.phone',
                    cba.phone_ext as 'contact.phoneExt',
                    cba.email as 'contact.email',
                    cba.attention_to as 'address.attentionTo',
                    cba.line_1 as 'address.line1',
                    cba.line_2 as 'address.line2',
                    cba.line_3 as 'address.line3',
                    cba.city as 'address.city',
                    cba.state as 'address.state',
                    cba.country as 'address.country',
                    cba.zip as 'address.zip',
                    cba.po_box_number as 'address.poBoxNo',
                    cba.is_using_verified as 'address.isUsingVerified',
                    cba.verified_line_1 as 'address.verified.line1',
                    cba.verified_line_2 as 'address.verified.line2',
                    cba.verified_line_3 as 'address.verified.line3',
                    cba.verified_city as 'address.verified.city',
                    cba.verified_state as 'address.verified.state',
                    cba.verified_country as 'address.verified.country',
                    cba.verified_zip as 'address.verified.zip',
                    cba.verified_po_box_number as 'address.verified.poBoxNo',
                    JSON_QUERY((select '['+string_agg(jsn,',')+']' from con where billing_account = cba.id and sage_account is null)) contacts,
                    (
                        select
                            csa.id,
                            csa.sage_account_id as 'sageAccId',
                            csa.customer_billing_account as 'billAccId',
                            cba.customer_parent as 'parentId',
                            case when cas.name = 'Active' then CAST(1 as bit) else CAST(0 as bit) end as 'isActive',
                            csa.account_status as 'accountStatus',
                            csa.sage_company_division 'sageCompanyDivision',
                            scd.sage_division_id as 'sageDivisionId',
                            sc.id as 'sageCompany',
                            sc.name as 'name',
                            sc.company_type as 'companyType',
                            JSON_QUERY((select '['+string_agg(jsn,',')+']' from con where sage_account = csa.id)) contacts,
                            null as locations,
                            csa.sage_status as 'status.code',
                            csa.sage_failed_reason_message as 'status.message',
                            csa.[_created_on] createdOn,
                            csa.[_created_by] createdBy,
                            csa.[_valid_from] updatedOn,
                            csa.[_updated_by] updatedBy
                        from
                            customer_sage_accounts csa join customer_account_statuses cas on csa.account_status = cas.id
                            join sage_company_divisions scd on scd.id = csa.sage_company_division join sage_companies sc on sc.id = scd.sage_company
                            -- join customer_billing_accounts cba on cba.customer_parent= @id and csa.customer_billing_account = cba.id
                        where
                            csa.id in (select sage_account from con) and csa.customer_billing_account = cba.id
                        FOR JSON PATH, INCLUDE_NULL_VALUES
                    ) sageAccounts
                FROM
                    customer_billing_accounts cba 
                WHERE
                    cba.customer_parent = @id
                FOR JSON PATH, INCLUDE_NULL_VALUES
        ) billingAccounts
    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER
    ) 
    select @json_text=jsn_txt from a;
	RETURN @json_text;
END
GO

