module Slack::API
  module Base
    extend ActiveSupport::Concern
    included do
      attr_reader :uri, :params

      private

      def post
        req = Net::HTTP::Post.new URI(uri).request_uri
        req.set_form_data(
          Hash(params).merge(token: Rails.application.secrets.slack_token)
        )

        http(uri).request req
      end

      def http(uri)
        http = Net::HTTP.new uri.host, uri.port
        http.use_ssl = (uri.scheme == "https")

        http
      end
    end
  end
end
