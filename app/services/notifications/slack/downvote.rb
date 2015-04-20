module Notifications::Slack
  class Downvote
    include Base

    attr_reader :link

    def initialize(link)
      @link = link
    end

    def call
      send_message(message)
    end

    private

    def message
      I18n.t(
        'slack.notifications.downvote',
        votes_count: link.votes_for.size,
        url: link.url
      )
    end
  end
end

