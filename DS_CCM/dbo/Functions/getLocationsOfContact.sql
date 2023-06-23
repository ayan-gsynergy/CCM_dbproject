CREATE function [dbo].[getLocationsOfContact](@id int)
returns nvarchar(max)
as
BEGIN
	declare @json_text nvarchar(max);
    with con as 
        (select c_out.id,c_out.location,(
            select 
                c_in.id,
                --c_in.address_type addressType,
                null type,
                c_in.is_active isActive,
                concat(p.name_first,case when len(p.name_middle)>0 then ' ' end,p.name_middle,case when len(p.name_last)>0 then ' ' end ,p.name_last) as 'name',
                p.name_first firstName,
                p.name_middle middleName,
                p.name_last lastName,
                p.id personId,
                --c_in.location locationId,
                --c_in.parent parentId,
                --c_in.billing_account billingAccId,
                --c_in.sage_account sageAccId,
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
                pape.verified_po_box_number as 'address.verified.poBoxNo'
                --,c_in.[_created_on] createdOn
                --,c_in.[_created_by] createdBy
                --,c_in.[_valid_from] updatedOn
                --,c_in.[_updated_by] updatedBy
            from contacts c_in join persons p on p.id = c_in.person 
                join person_adrs_ph_email pape on (pape.person = p.id and ((c_in.address_type = 'CCM_PRIMARY' and pape.id= p.primary_adrs_ph_email) or pape.type = c_in.address_type))
            where c_in.id = c_out.id
            for JSON PATH, INCLUDE_NULL_VALUES
        ) as jsn 
        from contacts c_out 
        where person =@id and location is not null)
        ,a(jsn_txt) as
        (select
            l.id,
            null parentLocationId,
            null sageAccLocationId,
            null billingLocationId,
            l.is_active isActive,
            null isSageLocationActive,
            null isParentLocationActive,
            l.premise_id premiseId,
            l.site_size siteSize,
            l.pm_site_code pmSiteCode,
            l.name,
            l.ddbt,
            l.desired_head_count desiredHeadCount,
            l.type,
            lt.name typeName,
            l.phone,
            l.phone_ext phoneExt,
            l.email,
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
            l.is_using_verified,
            l.receives_offsite_gilts 'receivesOffsiteGilts',
            con.jsn as contacts,
            null billingAccounts,
            l._created_on createdOn,
            l._created_by createdBy,
            l._valid_from updatedOn,
            l._updated_by updatedBy
        FROM
            locations l join location_types lt on l.type = lt.id join con on con.location = l.id
        FOR JSON PATH, INCLUDE_NULL_VALUES)
        select @json_text= jsn_txt from a;
	RETURN @json_text;
END;
GO

