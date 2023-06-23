CREATE function [dbo].[getAccountsOfLocation](@id int)
returns nvarchar(max)
as
BEGIN
	declare @json_text nvarchar(max);
    with loc AS(
        SELECT
            csa.customer_billing_account billingAccount,
            csal.customer_sage_account sageAccount,
            (select 
                l.id 'id',
                null 'parentLocationId',
                csal.id 'sageAccLocationId',
                null as 'billingLocationId',
                l.is_active 'isActive',
                csal.is_active 'isSageLocationActive',
                null 'isParentLocationActive',
                l.premise_id 'premiseId',
                l.site_size 'siteSize',
                l.pm_site_code 'pmSiteCode',
                csal.sage_ship_to_code 'shipToCode',
                l.name 'name',
                l.ddbt 'ddbt',
                l.desired_head_count 'desiredHeadCount',
                l.type 'type',
                lt.name 'typeName',
                l.phone 'phone',
                l.phone_ext 'phoneExt',
                l.email 'email',
                l.line_1 'address.line1',
                l.line_2 'address.line2',
                l.line_3 'address.line3',
                l.city 'address.city',
                l.state 'address.state',
                l.country 'address.country',
                l.zip 'address.zip',
                l.po_box_number 'address.poBoxNo',
                l.is_using_verified 'address.isUsingVerified',
                l.verified_line_1 'address.verified.line1',
                l.verified_line_2 'address.verified.line2',
                l.verified_line_3 'address.verified.line3',
                l.verified_city 'address.verified.city',
                l.verified_state 'address.verified.state',
                l.verified_country 'address.verified.country',
                l.verified_zip 'address.verified.zip',
                l.verified_po_box_number 'address.verified.poBoxNo',
                l.is_using_verified 'is_using_verified',
                l.receives_offsite_gilts 'receivesOffsiteGilts',
                null 'billingAccounts',
                l._created_on 'createdOn',
                l._created_by 'createdBy',
                csal._valid_from 'updatedOn',
                csal._updated_by 'updatedBy',
                csal.sage_status as 'status.code',
                csal.sage_failed_reason_message as 'status.message'
                FOR JSON PATH, INCLUDE_NULL_VALUES
            ) jsn
        FROM
            locations l
        join location_types lt on l.type = lt.id
        left join customer_sage_acc_locations csal on csal.[location]=l.id
        left join customer_sage_accounts csa on csa.id = csal.customer_sage_account
        WHERE l.id = @id
        ),
        a(jsn_txt) as
        (select 
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
            null as locations,
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
                    null as contacts,
                    loc.jsn as locations,
                    csa.sage_status as 'status.code',
                    csa.sage_failed_reason_message as 'status.message',
                    csa.[_created_on] createdOn,
                    csa.[_created_by] createdBy,
                    csa.[_valid_from] updatedOn,
                    csa.[_updated_by] updatedBy
                from
                    customer_sage_accounts csa join customer_account_statuses cas on csa.account_status = cas.id
                    join sage_company_divisions scd on scd.id = csa.sage_company_division join sage_companies sc on sc.id = scd.sage_company
                    join loc on loc.sageAccount=csa.id
                where
                        csa.customer_billing_account = cba.id
                for JSON PATH, INCLUDE_NULL_VALUES
            )sageAccounts,
            null as contacts
        FROM
            customer_billing_accounts cba
        where
            cba.id in (select billingAccount from loc) 
        FOR JSON PATH, INCLUDE_NULL_VALUES)
    select @json_text= jsn_txt from a;
	RETURN @json_text;
END;
GO

