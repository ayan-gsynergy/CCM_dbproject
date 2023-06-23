

CREATE FUNCTION  [dbo].[getAccountsOfParent] (@id int)  
 RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
   RETURN (
		select
			cba.id,
			cba.name,
			cba.customer_parent 'parentId',
			phone 'contact.phone',
			phone_ext 'contact.phoneExt',
			email 'contact.email',
			attention_to 'address.attentionTo',
			line_1 'address.line1',
			line_2 'address.line2',
			line_3 'address.line3',
			city 'address.city',
			state 'address.state',
			country 'address.country',
			zip 'address.zip',
			po_box_number 'address.poBoxNo',
			is_using_verified 'address.isUsingVerified',
			verified_line_1 'address.verified.line1',
			verified_line_2 'address.verified.line2',
			verified_line_3 'address.verified.line3',
			verified_city 'address.verified.city',
			verified_state 'address.verified.state',
			verified_country 'address.verified.country',
			verified_zip 'address.verified.zip',
			verified_po_box_number 'address.verified.poBoxNo',
			isnull(
				(
					select
						csa.id,
						cast(
							case
								when account_status = 2 then 0
								else 1
							end as bit
						) 'isActive',
						cba.customer_parent 'parentId',
						csa.customer_billing_account 'billAccId',
						csa.sage_company_division 'sageCompanyDivision',
						csa.sage_account_id 'sageAccId',
						csa.account_status 'accountStatus',
						sc.name,
						sc.id 'sageCompany',
						scd.sage_division_id 'sageDivisionId',
						sc.company_type 'companyType',
						isnull(
							(
								select
									c.id,
									c.address_type 'addressType',
									c.is_active 'isActive',
									string_agg(ct.name, ',') 'type',
									max(p.name_first) 'firstName',
									max(p.name_middle) 'middleName',
									max(p.name_last) 'lastName',
									case
										when max(p.name_middle) is null then concat(max(p.name_first), ' ', max(p.name_last))
										else concat(
											max(p.name_first),
											' ',
											max(p.name_middle),
											' ',
											max(p.name_last)
										)
									end 'name',
									JSON_QUERY('[' + string_agg(cct.contact_type, ',') + ']') contactTypes,
									JSON_QUERY(
										isnull(
											(
												select
													'[' + string_agg(distribution_list, ',') + ']'
												from
													contact_distribution_list cdl
												where
													cdl.contact = c.id
											),
											'[]'
										)
									) contactDistributions,
									isnull(
										(
											select
												sac.id,
												c.sage_account 'accId' for json path,
												INCLUDE_NULL_VALUES
										),
										'[]'
									) sageContact,
									max(sac.sage_contact_code) 'sageContactCode',
									max(pape.phone) 'contact.phone',
									max(pape.phone_ext) 'contact.phoneExt',
									max(pape.email) 'contact.email',
									max(pape.line_1) 'address.line1',
									max(pape.line_2) 'address.line2',
									max(pape.line_3) 'address.line3',
									max(pape.city) 'address.city',
									max(pape.state) 'address.state',
									max(pape.country) 'address.country',
									max(pape.zip) 'address.zip',
									max(pape.po_box_number) 'address.poBoxNo',
									pape.is_using_verified 'address.isUsingVerified',
									max(pape.verified_line_1) 'address.verified.line1',
									max(pape.verified_line_2) 'address.verified.line2',
									max(pape.verified_line_3) 'address.verified.line3',
									max(pape.verified_city) 'address.verified.city',
									max(pape.verified_state) 'address.verified.state',
									max(pape.verified_country) 'address.verified.country',
									max(pape.verified_zip) 'address.verified.zip',
									max(pape.verified_po_box_number) 'address.verified.poBoxNo',
									max(c.person) 'personId',
									max(c.[location]) 'locationId',
									max(c.parent) 'parentId',
									max(c.billing_account) 'billingAccId',
									max(c.sage_account) 'sageAccId',
									max(c._created_on) 'createdOn',
									max(c._updated_by) 'updatedBy',
									max(c._valid_from) 'updatedOn',
									csa.sage_status 'status.code',
									csa.sage_failed_reason_message 'status.message'
								from
									contacts c
									join persons p on c.person = p.id
									join person_adrs_ph_email pape on (
										pape.person = p.id
										and (
											(c.address_type = 'CCM_PRIMARY' and pape.id = p.primary_adrs_ph_email)
											or pape.type = c.address_type
										)
									)
									join contact_contact_types cct on cct.contact = c.id
									join contact_types ct on ct.id = cct.contact_type
									left join sage_account_contacts sac on sac.contact = c.id
								where
									c.sage_account = csa.id
								group by
									c.id,
									c.address_type,
									c.is_active,
									sac.id,
									c.sage_account,
									pape.is_using_verified for json path,
									INCLUDE_NULL_VALUES
							),
							'[]'
						) contacts,
						isnull(
							(
								select
									csal.location 'id',
									null 'parentLocationId',
									csal.id 'sageAccLocationId',
									null 'billingLocationId',
									cast(l.is_active as bit) 'isActive',
									cast(csal.is_active as bit) 'isSageLocationActive',
									cast(
										case
											when pl.is_active is null then 0
											else pl.is_active
										end as bit
									) 'isParentLocationActive',
									l.premise_id 'premiseId',
									l.site_size 'siteSize',
									l.pm_site_code 'pmSiteCode',
									l.name,
									l.ddbt,
									l.desired_head_count 'desiredHeadCount',
									l.[type],
									lt.name 'typeName',
									l.phone,
									l.phone_ext 'phoneExt',
									l.email,
									line_1 'address.line1',
									line_2 'address.line2',
									line_3 'address.line3',
									city 'address.city',
									state 'address.state',
									country 'address.country',
									zip 'address.zip',
									po_box_number 'address.poBoxNo',
									is_using_verified 'address.isUsingVerified',
									verified_line_1 'address.verified.line1',
									verified_line_2 'address.verified.line2',
									verified_line_3 'address.verified.line3',
									verified_city 'address.verified.city',
									verified_state 'address.verified.state',
									verified_country 'address.verified.country',
									verified_zip 'address.verified.zip',
									verified_po_box_number 'address.verified.poBoxNo',
									l.is_using_verified 'is_using_verified',
									l.receives_offsite_gilts 'receivesOffsiteGilts',
									JSON_QUERY('[]') 'billingAccounts',
									l._created_on 'createdOn',
									l._created_by 'createdBy',
									l._valid_from 'updatedOn',
									l._updated_by 'updatedBy',
									csal.sage_status 'status.code',
									csal.sage_failed_reason_message 'status.message'
								from
									customer_sage_acc_locations csal
									join locations l on csal.location = l.id
									left join parent_locations pl on csal.location = pl.location
									join location_types lt on l.[type] = lt.id
								where
									csal.customer_sage_account = csa.id for json path,
									INCLUDE_NULL_VALUES
							),
							'[]'
						) locations,
						csa._created_on 'createdOn',
						csa._created_by 'createdBy',
						csa._valid_from 'updatedOn',
						csa._updated_by 'updatedBy',
						csa.sage_status 'status.code',
						csa.sage_failed_reason_message 'status.message'
					from
						customer_sage_accounts csa
						join sage_company_divisions scd on csa.sage_company_division = scd.id
						join sage_companies sc on scd.sage_company = sc.id
					where
						csa.customer_billing_account = cba.id for json path,
						INCLUDE_NULL_VALUES
				),
				'[]'
			) sageAccounts,
			isnull(
				(
					select
						c.id,
						c.address_type 'addressType',
						c.is_active 'isActive',
						string_agg(ct.name, ',') 'type',
						max(p.name_first) 'firstName',
						max(p.name_middle) 'middleName',
						max(p.name_last) 'lastName',
						case
							when max(p.name_middle) is null then concat(max(p.name_first), ' ', max(p.name_last))
							else concat(
								max(p.name_first),
								' ',
								max(p.name_middle),
								' ',
								max(p.name_last)
							)
						end 'name',
						JSON_QUERY('[' + string_agg(cct.contact_type, ',') + ']') contactTypes,
						JSON_QUERY(
							isnull(
								(
									select
										'[' + string_agg(distribution_list, ',') + ']'
									from
										contact_distribution_list cdl
									where
										cdl.contact = c.id
								),
								'[]'
							)
						) contactDistributions,
						(
							select
								top 1 sage_contact_code
							from
								sage_account_contacts sac
							where
								sac.contact = c.id
							order by
								sage_contact_code
						) as sageContactCode,
						max(pape.phone) 'contact.phone',
						max(pape.phone_ext) 'contact.phoneExt',
						max(pape.email) 'contact.email',
						max(pape.line_1) 'address.line1',
						max(pape.line_2) 'address.line2',
						max(pape.line_3) 'address.line3',
						max(pape.city) 'address.city',
						max(pape.state) 'address.state',
						max(pape.country) 'address.country',
						max(pape.zip) 'address.zip',
						max(pape.po_box_number) 'address.poBoxNo',
						pape.is_using_verified 'address.isUsingVerified',
						max(pape.verified_line_1) 'address.verified.line1',
						max(pape.verified_line_2) 'address.verified.line2',
						max(pape.verified_line_3) 'address.verified.line3',
						max(pape.verified_city) 'address.verified.city',
						max(pape.verified_state) 'address.verified.state',
						max(pape.verified_country) 'address.verified.country',
						max(pape.verified_zip) 'address.verified.zip',
						max(pape.verified_po_box_number) 'address.verified.poBoxNo',
						max(c.person) 'personId',
						max(c.[location]) 'locationId',
						max(c.parent) 'parentId',
						max(c.billing_account) 'billingAccId',
						max(c.sage_account) 'sageAccId',
						max(c._created_on) 'createdOn',
						max(c._updated_by) 'updatedBy',
						max(c._valid_from) 'updatedOn',
						JSON_QUERY('[]') 'billingAccounts',
						JSON_QUERY(
							(
								select
									min(code) as code,
									string_agg(message, ', ') within group (
										order by
											message
									) as 'message'
								from
		(
										select
											distinct sage_failed_reason_message message,
											min(sage_status) over() 'code'
										from
											sage_account_contacts sac
										where
											contact = c.id
									) a for JSON PATH,
									WITHOUT_ARRAY_WRAPPER,
									INCLUDE_NULL_VALUES
							)
						) as 'status'
					from
						contacts c
						join persons p on c.person = p.id
						join person_adrs_ph_email pape on (
							pape.person = p.id
							and (
								(c.address_type = 'CCM_PRIMARY' and pape.id = p.primary_adrs_ph_email)
								or pape.type = c.address_type
							)
						)
						join contact_contact_types cct on cct.contact = c.id
						join contact_types ct on ct.id = cct.contact_type
					where
						c.billing_account = cba.id
					group by
						c.id,
						c.address_type,
						c.is_active,
						c.sage_account,
						pape.is_using_verified for json path,
						INCLUDE_NULL_VALUES
				),
				'[]'
			) contacts -- billingAccounts.contacts
		from
			customer_billing_accounts cba
		where
			customer_parent = @id for json path,
			INCLUDE_NULL_VALUES
   )  
END
GO

