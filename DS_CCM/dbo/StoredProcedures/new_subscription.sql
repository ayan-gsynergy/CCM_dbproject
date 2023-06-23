CREATE procedure dbo.new_subscription (
          @apiKey varchar(128), 
          @callbackUrl varchar(MAX), 
          @criteria varchar(MAX),
          @credentials varchar(MAX),
          @id int output)
          AS
          BEGIN
          SET NOCOUNT ON;
          SET @id = next value for persons_seq;
          INSERT INTO subscriptions(id, api_key, callback_url,criteria, credentials) 
          values(@id ,@apiKey, @callbackUrl, @criteria, @credentials);
          END
GO

