CREATE function [dbo].[getDetailsOfContact](@id int)
returns nvarchar(max)
as
BEGIN
	declare @json_text nvarchar(max);
    with a(jsn_txt) as(
    select
        p.id,
        concat(p.name_first,case when len(p.name_middle)>0 then ' ' end,p.name_middle,case when len(p.name_last)>0 then ' ' end ,p.name_last) as 'name',
        p.name_first firstName,
        p.name_middle middleName,
        p.name_last lastName,
        null contactTypes,
        (
            select distinct dl.name,dl.description 
            from distribution_lists dl join contact_distribution_list cdl on cdl.distribution_list = dl.id join contacts c on c.id = cdl.contact where c.person = p.id
            FOR JSON PATH, INCLUDE_NULL_VALUES
        ) distributionLists,
        (
            select
                cast(case when p.primary_adrs_ph_email = pape.id then 1 else 0 end as bit) isPrimary,
                pape.person ,
                pape.id,
                pape.type,
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
                pape.is_using_verified,
                null as contactTypeIds,
                JSON_QUERY(
                    (select '['+string_agg(dl_id,',')+']'
                    from (
                            select distinct cdl.distribution_list dl_id 
                            from contact_distribution_list cdl join contacts c on c.id = cdl.contact 
                            where c.person = p.id and ((c.address_type = 'CCM_PRIMARY' and pape.id= p.primary_adrs_ph_email) or pape.type = c.address_type)
                        )a )
                ) distributionListIds
            from person_adrs_ph_email pape
            where pape.person = p.id
            FOR JSON PATH, INCLUDE_NULL_VALUES
        )addresses,
        p.[_updated_by] updatedBy
    from persons p
    where p.id = @id
    FOR JSON PATH, INCLUDE_NULL_VALUES)
        select @json_text= jsn_txt from a;
	RETURN @json_text;
END;
GO

