CREATE proc [dbo].[ins_sage_acc_contacts](
    @inp_jsn nvarchar(max),
    @out_jsn nvarchar(max) out
)
as
BEGIN

    insert into sage_account_contacts(sage_account,contact,sage_contact_code)
    select inp.sageAccId,inp.contactId,sac.sage_contact_code from
    (
        select a.sageAccId,a.contactId,pape.id pAdrsId from openjson (@inp_jsn, '$.sageAccountContacts' )
        with (
            sageAccId int,
            contactId int
        ) a 
        join contacts c on c.id = a.contactId
        join persons p on c.person = p.id
        join person_adrs_ph_email pape on pape.person = p.id and ((c.address_type = 'CCM_PRIMARY' and p.primary_adrs_ph_email = pape.id) or c.address_type = pape.[type])
    )inp left join
    (
        select sac.sage_account sageAccId,max(sac.sage_contact_code) sage_contact_code,pape.id pAdrsId from sage_account_contacts sac 
        join contacts c on c.id = sac.contact
        join persons p on c.person = p.id
        join person_adrs_ph_email pape on pape.person = p.id and ((c.address_type = 'CCM_PRIMARY' and p.primary_adrs_ph_email = pape.id) or c.address_type = pape.[type])
        group by sac.sage_account,pape.id
    ) sac on inp.sageAccId = sac.sageAccId 
            and inp.pAdrsId=sac.pAdrsId 
    where not exists (select 1 from sage_account_contacts where inp.sageAccId = sage_account and inp.contactId = contact);

    with tbl  as(
    select 
        c.is_active isActive, 
        sac.id ccmID,
        sac.sage_contact_code contactCode,
        cba.customer_parent parentID,
        cba.id billingAccount,
        csa.sage_company_division sageCompanyDivision,
        csa.id sageAccount,
        p.id person,
        c.id contact,
        csa.sage_account_id customerNo,
        scd.sage_company companyCode,
        scd.sage_division_id arDivisionNo,
        concat(p.name_first,case when len(p.name_middle)>0 then ' ' end,p.name_middle,case when len(p.name_last)>0 then ' ' end ,p.name_last) contactName,
        pape.line_1 addressLine1,
        pape.line_2 addressLine2,
        pape.line_3 addressLine3,
        pape.city ,
        pape.state,
        pape.zip zipCode,
        pape.email emailAddress,
        pape.phone telephoneNo,
        pape.phone_ext telephoneExt
    from
        sage_account_contacts sac 
        join (select * from openjson (@inp_jsn, '$.sageAccountContacts')
                with (
                    sageAccId int,
                    contactId int)
            )jsn_tbl on    sac.sage_account = jsn_tbl.sageAccId 
                        and sac.contact = jsn_tbl.contactId
        join contacts c on c.id = sac.contact
        join customer_sage_accounts csa on csa.id = sac.sage_account
        join customer_billing_accounts cba on cba.id = csa.customer_billing_account
        join sage_company_divisions scd on scd.id = csa.sage_company_division
        join persons p on c.person = p.id
        join person_adrs_ph_email pape on pape.person = p.id and ((c.address_type = 'CCM_PRIMARY' and p.primary_adrs_ph_email = pape.id) or c.address_type = pape.[type])
    ),
    a(jsn_txt) as
    (
    select
    (select
        isActive,
        cast(ccmID as varchar) ccmID,
        cast(parentID as varchar) parentID,
        case when customerNo is null then '' else customerNo end customerNo,
        companyCode,
        arDivisionNo,
        contactCode,
        case when contactName is null then '' else contactName end contactName,
        case when addressLine1 is null then '' else addressLine1 end addressLine1,
        case when addressLine2 is null then '' else addressLine2 end addressLine2,
        case when addressLine3 is null then '' else addressLine3 end addressLine3,
        case when city is null then '' else city end city,
        case when state is null then '' else state end state,
        case when zipCode is null then '' else zipCode end zipCode,
        case when emailAddress is null then '' else emailAddress end emailAddress ,
        case when telephoneNo is null then '' else telephoneNo end telephoneNo
    from tbl FOR JSON PATH) as sageCallData,
    (select JSON_VALUE(@inp_jsn,'$.requestID') as requestId, ccmId, parentID parent,billingAccount,sageCompanyDivision,sageAccount,person,contact,'PENDING' as status
    from tbl FOR JSON PATH, INCLUDE_NULL_VALUES) as jobCreationData
    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER)
    select @out_jsn = jsn_txt from a;
    ;

END;
GO

