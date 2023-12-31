CREATE PROC [dbo].[new_customer_parent](
	@name				varchar(120),
	@type				INT  = NULL,
	@production_type		INT  = NULL,
	@estimated_sows		INT  = NULL,
	@estimated_hogs		INT  = NULL,
	@phone				varchar(20) = NULL,
	@phone_ext			varchar(10) = NULL,
	@email				varchar(100) = NULL,
	@attention_to        varchar(120) = NULL,
	@line_1				varchar(120) = NULL,
	@line_2				varchar(120) = NULL,
	@line_3				varchar(120) = NULL,
	@city				varchar(60) = NULL,
	@state				varchar(60) = NULL,
	@country			varchar(3) = NULL,
	@zip				varchar(20) = NULL,
	@po_box_number		varchar(20) = NULL,
	@verified_freeform_address      varchar(300) = NULL,
	@hash_of_verified_address       varchar(50) = NULL,
	@verified_line1     varchar(120) = NULL,
    @verified_line2     varchar(120) = NULL,
    @verified_line3     varchar(120) = NULL,
    @verified_city      varchar(60) = NULL,
    @verified_state     varchar(60) = NULL,
    @verified_country   varchar(3) = NULL,
    @verified_zip       varchar(20) = NULL,
    @verified_po_box_number   varchar(20) = NULL,
    @is_using_verified    BIT = 0,
	@created_by			varchar(120),
	@updated_by			varchar(120),
	@updated_by_action 	char(32),
	@id INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	SET @id = next value for customer_parents_seq;
	insert into dbo.customer_parents 
		(id,
		 name,
		 [type] ,
		 production_type ,
		 estimated_sows ,
		 estimated_hogs ,
		 phone,
		 phone_ext,
		 email,
		 attention_to ,
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
		 verified_line_1 ,
		 verified_line_2 ,
		 verified_line_3 ,
		 verified_city ,
		 verified_state ,
		 verified_country ,
		 verified_zip ,
		 verified_po_box_number ,
		 is_using_verified ,
		 _created_by,
		 _updated_by,
		 _updated_by_action)
	values 
		(@id,
		 @name				,
		 @type              ,
		 @production_type    ,
		 @estimated_sows     ,
		 @estimated_hogs     ,
		 @phone				,
		 @phone_ext			,
		 @email				,
		 @attention_to       ,
		 @line_1			,
		 @line_2			,
		 @line_3			,
		 @city				,
		 @state				,
		 @country			,
		 @zip				,
		 @po_box_number		,
		 @verified_freeform_address,
		 @hash_of_verified_address,
		 @verified_line1   ,
		 @verified_line2   ,
		 @verified_line3   ,
		 @verified_city	    ,
		 @verified_state    ,
		 @verified_country	,
		 @verified_zip		,
		 @verified_po_box_number  ,
		 @is_using_verified   ,
		 @created_by        ,
		 @updated_by   		,
		 @updated_by_action )
END;
GO

