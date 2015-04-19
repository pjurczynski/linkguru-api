module Parsers
  class TriggerWord
    attr_reader :trigger_word

    def initialize(trigger_word)
      @trigger_word = trigger_word
    end

    def create?
      keyword?(trigger_words['create_link'])
    end

    def upvote?
      keyword?(trigger_words['upvote'])
    end

    def downvote?
      keyword?(trigger_words['downvote'])
    end

    private

    def keyword?(valid_keywords)
      Regexp.new("(?:#{valid_keywords.join('|')})")
        .match(trigger_word).present?
    end

    def trigger_words
      Rails.application.secrets.trigger_words
    end
  end
end
