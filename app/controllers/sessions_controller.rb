class SessionsController < ApplicationController
  def create
    g_user = GoogleOauthAuthorizer.new(params)
    if allowed_domains.include?(g_user.domain)
      user = User.where(email: g_user.email).first_or_create(name: g_user.display_name)
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
