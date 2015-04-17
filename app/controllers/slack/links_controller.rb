module Slack
  class LinksController < SlackController
    before_action :authenticate_slack!

    def create
      link = Link.new(link_params)
      link.user = current_slack_user
      if link.save
        Notifications::Slack::Link.new(link).call
        message = "You're gorgeous! We love new links omnomnom!"
      else
        message = "Go to LinkGuru and fix some bugs.. \
                   because I couldn't create that link ;(."
      end
      render json: { text: message }
    end

    private

    def link_params
      {
        url: parsed_link,
        description: parsed_description,
        tag_list: parsed_tag_list,
      }
    end

    def parsed_link
      text = params.fetch(:text)
      matched = /#{keywords_regex}<(?<url>[^>]*)>/.match(text)
      matched[:url] if matched.present?
    end

    def parsed_description
      text = params.fetch(:text)
      matched = /#{keywords_regex}<[^>]*> (?<description>)[^#]*/.match(text)
      matched[:description] if matched.present?
    end

    def parsed_tag_list
      text = params.fetch(:text)
      text.scan(/(<?#\S*>?)/)
    end

    def keywords_regex
      '(?:add link|linkguru) '
    end
  end
end
