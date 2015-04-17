require 'google/api_client'
require 'google/api_client/client_secrets'

class GoogleOauthAuthorizer
  def call
    authorization.code = params[:code]
    authorization.fetch_access_token!
    client.authorization = authorization

    plus = client.discovered_api('plus', 'v1')
    response = client.execute!(plus.people.get, userId: 'me')

    extract_email(JSON.parse(response.body))
  end

  private

  def extract_email(body)
    body['emails'].select{ |x| x['type'] == 'account' }.first['value']
  end

  def authorization
    @authorization ||= Signet::OAuth2::Client.new(
      authorization_uri: google_credentials.authorization_uri,
      token_credential_uri: google_credentials.token_credential_uri,
      client_id: google_credentials.client_id,
      client_secret: google_credentials.client_secret,
      redirect_uri: google_credentials.redirect_uris.first,
      access_type: 'offline',
      scope: 'email')
  end

  def client
    @client ||= Google::APIClient.new
  end

  def google_credentials
    Google::APIClient::ClientSecrets.load
  end
end
