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
      "total votes: #{link.votes_for.size}, for #{link.url}"
    end
  end
end

