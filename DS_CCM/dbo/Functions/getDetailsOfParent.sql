CREATE FUNCTION  [dbo].[getDetailsOfParent] (@id int)  
 RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
   RETURN (select
				cp.id,
				cp.type customerType,
				pt.name customerTypeName,
				ppt.name productionTypeName,
				cp.production_type productionType,
				cp.estimated_sows estimatedSows,
				cp.estimated_hogs estimatedHogs,
				cp.name,
				attention_to 'address.attentionTo',
				line_1 'address.line1',
				line_2 'address.line2',
				line_3 'address.line3',
				city 'address.city',
				state 'address.state',
				zip 'address.zip',
				country 'address.country',
				po_box_number 'address.poBoxNo',
				is_using_verified 'address.isUsingVerified',
				verified_line_1 'address.verified.line1',
				verified_line_2 'address.verified.line2',
				verified_line_3 'address.verified.line3',
				verified_city 'address.verified.city',
				verified_state 'address.verified.state',
				verified_zip 'address.verified.zip',
				verified_country 'address.verified.country',
				verified_po_box_number 'address.verified.poBoxNo',
				phone 'contact.phone',
				phone_ext 'contact.phoneExt',
				email 'contact.email',
				cp._created_on createdOn,
				cp._created_by createdBy,
				cp._updated_by updatedBy,
				cp._valid_from updatedOn,
				isnull(
					(
						select
							paiv.id,
							paiv.attribute 'attributeId',
							cast(paiv.value as bit) 'subscribed'
						from
							parent_attributes_investments_values paiv
						where
							paiv.parent = cp.id for json path
					),
					'[]'
				) investmentsData,
				isnull(
					(
						select
							papv.id,
							papv.attribute 'attributeId',
							cast(papv.value as bit) 'subscribed'
						from
							parent_attributes_partnerships_values papv
						where
							papv.parent = cp.id for json path
					),
					'[]'
				) partnershipsData,
				isnull(
					(
						select
							pv.id,
							pv.attribute 'attributeId',
							cast(pv.value as bit) 'subscribed'
						from
							parent_attributes_services_values pv
						where
							pv.parent = cp.id for json path
					),
					'[]'
				) servicesData,
				isnull(
					(
						select
							paovff.id,
							paovff.attribute 'attributeId',
							paovff.value 'subscribed'
						from
							parent_attributes_other_values_ff paovff
						where
							paovff.parent = cp.id for json path
					),
					'[]'
				) ffOtherData,
				isnull(
					(
						select
							paovl.id,
							paovli.attribute 'attributeId',
							paovli.value_id 'subscribed'
						from
							parent_attributes_other_values_lov paovl
							join parent_attributes_other_values_list paovli on paovl.attribute_value = paovli.id
						where
							paovl.parent = cp.id for json path
					),
					'[]'
				) lovOtherData,
				isnull(
					(
						select
							paovb.id,
							paovb.attribute 'attributeId',
							cast(paovb.value as bit) 'subscribed'
						from
							parent_attributes_other_values_bool paovb
						where
							paovb.parent = cp.id for json path
					),
					'[]'
				) boolOtherData
			from
				customer_parents cp
				left join parent_types pt on cp.type = pt.id
				left join parent_production_types ppt on cp.production_type = ppt.id
			where
				cp.id = @id for json path,
				INCLUDE_NULL_VALUES)  
END
GO

