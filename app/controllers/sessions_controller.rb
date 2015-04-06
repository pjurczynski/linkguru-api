require 'google/api_client'
require 'google/api_client/client_secrets'

PLUS_LOGIN_SCOPE = 'email'

$credentials = Google::APIClient::ClientSecrets.load
$authorization = Signet::OAuth2::Client.new(
    :authorization_uri => $credentials.authorization_uri,
    :token_credential_uri => $credentials.token_credential_uri,
    :client_id => $credentials.client_id,
    :client_secret => $credentials.client_secret,
    :redirect_uri => $credentials.redirect_uris.first,
    :access_type => 'offline',
    :scope => PLUS_LOGIN_SCOPE)
$client = Google::APIClient.new

$allowed_domians = %w(gmail.com netguru.co netguru.pl)

class SessionsController < ApplicationController

  def create
    $authorization.code = params[:code]
    $authorization.fetch_access_token!
    $client.authorization = $authorization

    plus = $client.discovered_api('plus', 'v1')
    response = $client.execute!(plus.people.get, userId: 'me')
    body = JSON.parse(response.body)
    email = body['emails'].select { |x| x['type'] == 'account' }.first['value']
    domain = email.split('@').last
    if $allowed_domians.include?(domain)
      user = User.where(email: email).first_or_create(name: body['displayName'])
      user.generate_token!
      respond_with user, serializer: UserSerializer, location: false
    else
      respond_with json: { error: true }, status: :unathorized
    end
  end

  def destroy
    current_user.update_attribute(:token, nil)
    respond_with json: {sucess: true}
  end
end
