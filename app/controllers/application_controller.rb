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

  protected

  def current_user
    User.find_by_token(request.headers['HTTP_TOKEN'])
  end

  def serializer_scope
    SerializserScope.new(current_user)
  end
end
