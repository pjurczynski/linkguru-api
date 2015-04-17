module Slack
  class LinksController < SlackController
    before_action :authenticate_slack!

    def create
      return unless create_keyword?
      link = Link.new(link_params)
      link.user = current_slack_user
      if link.save
        message = "You're gorgeous! We love new links omnomnom!
          You can now `downvote` or `upvote` that link!"
      else
        message = "Go to LinkGuru and fix some bugs.. \
                   because I couldn't create that link ;(."
      end
      render json: { text: message }
    end

    def last_upvote
      return unless upvote_keyword?
      link = Link.last
      link.upvote_by(current_slack_user)
      Notifications::Slack::Upvote.new(link).call
    end

    def last_downvote
      return unless downvote_keyword?
      link = Link.last
      link.downvote_by(current_slack_user)
      Notifications::Slack::Downvote.new(link).call
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
      matched = /#{keywords_regex} <(?<url>[^>]*)>/.match(text)
      matched[:url] if matched.present?
    end

    def parsed_description
      text = params.fetch(:text)
      matched = /#{keywords_regex} <[^>]*> (?<description>)[^#]*/.match(text)
      matched[:description] if matched.present?
    end

    def parsed_tag_list
      text = params.fetch(:text)
      text.scan(/(<?#\S*>?)/)
    end

    def keywords_regex
      '(?:add link|linkguru)'
    end

    def create_keyword?
      Regexp.new(keywords_regex).match(params[:trigger_word]).present?
    end

    def upvote_keyword?
      params[:trigger_word] == 'upvote'
    end

    def downvote_keyword?
      params[:trigger_word] == 'downvote'
    end
  end
end
