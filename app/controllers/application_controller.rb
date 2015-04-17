class SerializserScope
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end
end

class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::MimeResponds
  include ActionController::ImplicitRender

  serialization_scope :serializer_scope

  respond_to :json

  def default_serializer_options
    { root: false }
  end

  def authenticate!
    (respond_with json: { error: :untathorized }, status: :unauthorized) if current_user.nil?
  end

  protected

  def current_user
    @current_user ||= User.logged.find_by_token(request.headers['HTTP_TOKEN'])
  end

  def serializer_scope
    SerializserScope.new(current_user)
  end
end
