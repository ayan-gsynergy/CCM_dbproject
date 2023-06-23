create function [dbo].[getContactsOfLocation](@id int)
returns nvarchar(max)
as
BEGIN
	declare @json_text nvarchar(max);
    SET @json_text = (
        select 
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
            null as sageContactCode,
            null as 'status.code',
            null as 'status.message'
        from contacts c join persons p on p.id = c.person 
            join person_adrs_ph_email pape on (pape.person = p.id and ((c.address_type = 'CCM_PRIMARY' and pape.id= p.primary_adrs_ph_email) or pape.type = c.address_type))
        where c.location = @id
        for JSON PATH, INCLUDE_NULL_VALUES
    );
	RETURN @json_text;
END;
GO

