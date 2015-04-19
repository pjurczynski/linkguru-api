module Slack
  class LinksController < SlackController
    before_action :authenticate_slack!

    def create
      return unless trigger_word.create?
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
      return unless trigger_word.upvote?
      link = Link.first
      link.upvote_by(current_slack_user)
      Notifications::Slack::Upvote.new(link).call
    end

    def last_downvote
      return unless trigger_word.downvote?
      link = Link.first
      link.downvote_by(current_slack_user)
      Notifications::Slack::Downvote.new(link).call
    end

    private

    def link_params
      {
        url: parsed_link.url,
        description: parsed_link.description,
        tag_list: parsed_link.tag_list,
      }
    end

    def parsed_link
      @parsed_link ||= Parsers::Link.new(params.require(:text))
    end

    def trigger_word
      Parsers::TriggerWord.new(params.require(:trigger_word))
    end
  end
end
