CREATE procedure [dbo].[update_customer_parents] (
          @id int,
          @name varchar(120) = NULL,
          @type INT = NULL, 
          @production_type INT = NULL, 
          @estimated_sows INT = NULL,
          @estimated_hogs INT = NULL,
           @phone varchar(20) = NULL, 
          @phone_ext varchar(10) = NULL, 
          @email varchar(200) = NULL,
           @attention_to				varchar(120)= NULL,
          @line_1				varchar(120)= NULL,
	@line_2				varchar(120)= NULL,
	@line_3				varchar(120)= NULL,
	@city				varchar(60)= NULL,
	@state				varchar(60)= NULL,
	@country			varchar(3)= NULL,
	@zip				varchar(20)= NULL,
	@po_box_number		varchar(20)= NULL,
	@verified_freeform_address      varchar(300) = NULL,
	@hash_of_verified_address       varchar(50) = NULL,
	@verified_line_1				varchar(120)= NULL,
	@verified_line_2				varchar(120)= NULL,
	@verified_line_3				varchar(120)= NULL,
	@verified_city				varchar(60)= NULL,
	@verified_state				varchar(60)= NULL,
	@verified_country			varchar(3)= NULL,
	@verified_zip				varchar(20)= NULL,
	@verified_po_box_number		varchar(20)= NULL,
	@is_using_verified		BIT= NULL,
          @updated_by			varchar(120),
	      @updated_by_action 	char(32))
          AS
          BEGIN
          SET NOCOUNT ON;
          UPDATE customer_parents  
          SET name = COALESCE(@name, name),
           type = CASE WHEN @type = -1 THEN NULL ELSE COALESCE(@type, type) END,
          production_type  = CASE WHEN @production_type = -1 THEN NULL ELSE COALESCE(@production_type, production_type) END,
          estimated_sows  = COALESCE(@estimated_sows, estimated_sows),
          estimated_hogs  = COALESCE(@estimated_hogs, estimated_hogs),
          phone = COALESCE(@phone, phone),
          phone_ext = COALESCE(@phone_ext, phone_ext),
          email = COALESCE(@email, email),
          attention_to = COALESCE(@attention_to, attention_to),
          line_1 = COALESCE(@line_1, line_1),
          line_2 = COALESCE(@line_2, line_2),
          line_3 = COALESCE(@line_3, line_3),
          city = COALESCE(@city, city),
          state = COALESCE(@state, state),
          country = COALESCE(@country, country),
          zip = COALESCE(@zip, zip),
          po_box_number = COALESCE(@po_box_number, po_box_number),
           verified_freeform_address= COALESCE(@verified_freeform_address, verified_freeform_address),
		 hash_of_verified_address= COALESCE(@hash_of_verified_address, hash_of_verified_address),
          verified_line_1 = COALESCE(@verified_line_1, verified_line_1),
          verified_line_2 = COALESCE(@verified_line_2, verified_line_2),
          verified_line_3 = COALESCE(@verified_line_3, verified_line_3),
          verified_city = COALESCE(@verified_city, verified_city),
          verified_state = COALESCE(@verified_state, verified_state),
          verified_country = COALESCE(@verified_country, verified_country),
          verified_zip = COALESCE(@verified_zip, verified_zip),
          verified_po_box_number = COALESCE(@verified_po_box_number, verified_po_box_number),
          is_using_verified = COALESCE(@is_using_verified, is_using_verified),
          [_updated_by]=  @updated_by,
          [_updated_by_action] = @updated_by_action 
          WHERE id = @id;
          END
GO

