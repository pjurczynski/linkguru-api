module Slack::API
  class UserList
    include Base

    def initialize
      @uri = URI('https://slack.com/api/users.list')
    end

    def call
      users
    end

    private

    def users
      Rails.cache.fetch('slack_users', expires_in: 24.hours) do
        JSON.parse(post.body).fetch('members')
      end
    end
  end
end
