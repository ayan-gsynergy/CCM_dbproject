CREATE function [dbo].[getParentsOfContact](@id int)
returns nvarchar(max)
as
BEGIN
	declare @json_text nvarchar(max);
    with con as 
        (select c_out.id,isnull(c_out.parent,cba.customer_parent) parent,isnull(c_out.billing_account,csa.customer_billing_account) billing_account,c_out.sage_account,(
            select 
                c_in.id,
                c_in.address_type addressType,
                null type,
                c_in.is_active isActive,
                concat(p.name_first,case when len(p.name_middle)>0 then ' ' end,p.name_middle,case when len(p.name_last)>0 then ' ' end ,p.name_last) as 'name',
                p.name_first firstName,
                p.name_middle middleName,
                p.name_last lastName,
                p.id personId,
                c_in.location locationId,
                c_in.parent parentId,
                c_in.billing_account billingAccId,
                c_in.sage_account sageAccId,
                null billingAccounts,
                JSON_QUERY((select '['+string_agg(contact_type,',')+']' from contact_contact_types cct where cct.contact = c_in.id)) contactTypes,
                JSON_QUERY((select '['+string_agg(distribution_list,',')+']' from contact_distribution_list cdl where cdl.contact = c_in.id )) contactDistributions,
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
                c_in.[_created_on] createdOn,
                c_in.[_created_by] createdBy,
                c_in.[_valid_from] updatedOn,
                c_in.[_updated_by] updatedBy,
                (select top 1 sage_contact_code from sage_account_contacts sac where sac.contact = c_in.id order by sage_contact_code) as sageContactCode,
                JSON_QUERY((
                    select min(code) as code ,string_agg(message,', ') within group (order by message) as 'message' from(
                        select distinct sage_failed_reason_message message,min(sage_status) over() 'code' from sage_account_contacts sac where contact = c_in.id)a 
                    for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES
                )) as 'status'
            from contacts c_in join persons p on p.id = c_in.person 
                join person_adrs_ph_email pape on (pape.person = p.id and ((c_in.address_type = 'CCM_PRIMARY' and pape.id= p.primary_adrs_ph_email) or pape.type = c_in.address_type))
            where c_in.id = c_out.id
            for JSON PATH, INCLUDE_NULL_VALUES
        ) as jsn 
        from contacts c_out left join customer_sage_accounts csa on c_out.sage_account = csa.id
        left join customer_billing_accounts cba on cba.id = isnull(c_out.billing_account,csa.customer_billing_account)
        where person =@id and location is null)
        ,a(jsn_txt) as
        (select
            cp.id,
            cp.type customerType,
            cp.production_type productionType,
            ppt.name productionTypeName,
            cp.name,
            cp.phone as 'contact.phone',
            cp.phone_ext as 'contact.phoneExt',
            cp.email as 'contact.email',
            cp.attention_to as 'address.attentionTo',
            cp.line_1 as 'address.line1',
            cp.line_2 as 'address.line2',
            cp.line_3 as 'address.line3',
            cp.city as 'address.city',
            cp.state as 'address.state',
            cp.country as 'address.country',
            cp.zip as 'address.zip',
            cp.po_box_number as 'address.poBoxNo',
            cp.is_using_verified as 'address.isUsingVerified',
            cp.verified_line_1 as 'address.verified.line1',
            cp.verified_line_2 as 'address.verified.line2',
            cp.verified_line_3 as 'address.verified.line3',
            cp.verified_city as 'address.verified.city',
            cp.verified_state as 'address.verified.state',
            cp.verified_country as 'address.verified.country',
            cp.verified_zip as 'address.verified.zip',
            cp.verified_po_box_number as 'address.verified.poBoxNo',
            con.jsn as contacts,
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
                    con.jsn as contacts,
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
                            con.jsn as contacts,
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
                            join con on con.sage_account=csa.id
                        where
                                csa.customer_billing_account = cba.id
                        for JSON PATH, INCLUDE_NULL_VALUES
                    )sageAccounts,
                    null as locations
                FROM
                    customer_billing_accounts cba left join con on cba.id = con.billing_account and con.sage_account is null
                where
                        cba.customer_parent = cp.id 
                    and cba.id in (select billing_account from con) 
                FOR JSON PATH, INCLUDE_NULL_VALUES
            )billingAccounts
        from 
            customer_parents cp left join parent_production_types ppt on cp.production_type=ppt.id
            left join con on cp.id=con.parent and con.billing_account is null
        where
            cp.id in (select parent from con) 
        FOR JSON PATH, INCLUDE_NULL_VALUES)
        select @json_text= jsn_txt from a;
	RETURN @json_text;
END;
GO

