class SessionsController < ApplicationController
  def create
    email = GoogleOauthAuthorizer.new.call
    domain = email.split('@').last
    if allowed_domains.include?(domain)
      user = User.where(email: email).first_or_create(name: body['displayName'])
      user.generate_token!
      respond_with user, serializer: UserSerializer, location: false
    else
      render json: { body: 'You need to be in .netguru.co/pl domain to access this app.' }, status: :forbidden, location: nil
    end
  end

  def destroy
    current_user.update_attribute(:token, nil)
    respond_with json: { sucess: true }
  end

  private

  def allowed_domains
    %w(netguru.co netguru.pl)
  end
end
