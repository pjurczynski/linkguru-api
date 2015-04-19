module Parsers
  class Link
    attr_reader :body

    def initialize(body)
      @body = body
    end

    def url
      matched[:url]
    end

    def description
      matched[:description].try(:strip).presence || '** no description appended **'
    end

    def tag_list
      body.scan(/[^<]#(\S*)/) + body.scan(/(<#\S*>)/)
    end

    private

    def matched
      @matched ||= /<(?<url>[^>]*)> (?<description>[^#<]*)/.match(body) || {}
    end
  end
end
