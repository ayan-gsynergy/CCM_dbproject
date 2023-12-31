CREATE procedure [dbo].[new_person_address_ph_email] (
          @personId int,
          @type varchar(20), 
          @phone varchar(20) = NULL,
          @phone_ext varchar(10)  = NULL,
          @email varchar(100)  = NULL,
          @line_1 varchar(120)  = NULL,
          @line_2 varchar(120)  = NULL,
          @line_3 varchar(120)  = NULL,
          @city varchar(60)  = NULL,
          @state varchar(60)  = NULL,
          @country varchar(3)  = NULL,
          @zip varchar(20)  = NULL,
          @po_box_number varchar(20)  = NULL,
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
          @_updated_by varchar(120)  = NULL,
          @_updated_by_action char(32)  = NULL,
          @id int output)
          AS
          BEGIN
          SET NOCOUNT ON;
          SET @id = next value for person_adrs_ph_email_seq;
          INSERT INTO person_adrs_ph_email(
          id,
          person, 
          type, 
          phone, 
          phone_ext, 
          email, 
          line_1, 
          line_2, 
          line_3, 
          city,
          state, 
          country, 
          zip, 
          po_box_number,
          verified_freeform_address,
		 hash_of_verified_address,
          verified_line_1,
		 verified_line_2,
		 verified_line_3,
		 verified_city,
		 verified_state,
		 verified_country,
		 verified_zip,
		 verified_po_box_number,
		 is_using_verified,
          _updated_by, 
          _updated_by_action) 
          values(
        @id,
        @personId,
       @type, 
      @phone, 
     @phone_ext, 
    @email, 
    @line_1, 
   @line_2, 
  @line_3, 
 @city, 
@state, 
@country, 
@zip, 
@po_box_number,
 @verified_freeform_address,
		 @hash_of_verified_address,
@verified_line_1			,
		 @verified_line_2			,
		 @verified_line_3			,
		 @verified_city				,
		 @verified_state				,
		 @verified_country			,
		 @verified_zip				,
		 @verified_po_box_number		,
		 @is_using_verified,
@_updated_by, 
@_updated_by_action);
          END
GO

