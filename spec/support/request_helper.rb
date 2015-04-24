module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module RequestsHelpers
    def get_with_token(path, user = nil, params = {}, headers = {})
      headers = add_auth_headers(headers, user)
      get path, params, headers
    end

    def post_with_token(path, user = nil, params = {}, headers = {})
      headers = add_auth_headers(headers, user)
      post path, params, headers
    end

    def put_with_token(path, user = nil, params = {}, headers = {})
      headers = add_auth_headers(headers, user)
      put path, params, headers
    end

    def delete_with_token(path, user = nil, params = {}, headers = {})
      headers = add_auth_headers(headers, user)
      delete path, params, headers
    end

    private

    def add_auth_headers(headers, user)
      headers.merge(
        'HTTP_API_KEY' => AppConfig.api_keys.first,
        'HTTP_USER_API_TOKEN' => retrieve_access_token(user),
        'HTTP_ACCEPT' => 'application/json'
      )
    end

    def retrieve_access_token(user = nil)
      @user = user
      @user ||= FactoryGirl.create :user
      @session ||= Api::Session.create!(@user)
      @session.token
    end
  end
end
