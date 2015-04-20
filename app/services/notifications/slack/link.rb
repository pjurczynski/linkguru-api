module Notifications::Slack
  class Link
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
        'slack.notifications.create',
        url: create_link(link.url, link.url),
        description: link.description,
        tags: link.tags.join(', ')
      )
    end

    def create_link(name, url)
      "[#{name}](#{url})"
    end
  end
end
