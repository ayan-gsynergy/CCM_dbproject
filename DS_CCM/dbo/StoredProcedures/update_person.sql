CREATE procedure [dbo].[update_person] (
          @id int,
          @primary_adrs_ph_email_id int = NULL,
          @name_first varchar(120) = NULL, 
          @name_middle varchar(120) = NULL, 
          @name_last varchar(120) = NULL,
          @updated_by			varchar(120),
	      @updated_by_action 	char(32))
          AS
          BEGIN
          SET NOCOUNT ON;
          UPDATE persons 
          SET name_first = COALESCE(@name_first, name_first),
          primary_adrs_ph_email = COALESCE(@primary_adrs_ph_email_id, primary_adrs_ph_email),
          name_middle = COALESCE(@name_middle, name_middle),
          name_last = COALESCE(@name_last, name_last),
          [_updated_by] = @updated_by,
          [_updated_by_action] = @updated_by_action
          WHERE id = @id;
          END
GO

