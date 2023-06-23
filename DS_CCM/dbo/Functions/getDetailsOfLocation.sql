create function [dbo].[getDetailsOfLocation](@id int)
returns nvarchar(max)
as
BEGIN
	declare @json_text nvarchar(max);
    with a(jsn_txt) as
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
        null as contacts,
        null billingAccounts,
        l._created_on createdOn,
        l._created_by createdBy,
        l._valid_from updatedOn,
        l._updated_by updatedBy,
        null as 'status'
    FROM
        locations l join location_types lt on l.type = lt.id and l.id = @id
    FOR JSON PATH, INCLUDE_NULL_VALUES)
    select @json_text= jsn_txt from a;
	RETURN @json_text;
END;
GO

