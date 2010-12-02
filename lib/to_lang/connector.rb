require 'httparty'
require 'uri'

module ToLang
  class Connector
    include HTTParty

    API_URL = "https://www.googleapis.com/language/translate/v2"

    attr_reader :key

    def initialize(key)
      @key = key
    end

    def request(q, target, *args)
      response = self.class.get request_url(q, target, *args)
      response.parsed_response["data"]["translations"][0]["translatedText"]
    end

    private

    def request_url(q, target, *args)
      options = extract_options(*args)
      source = options[:from]
      url = "#{API_URL}?key=#{@key}&q=#{URI.escape(q)}&target=#{target}"
      url += "&source=#{source}" if source
      url
    end

    def extract_options(*args)
      if args.last.is_a? Hash
        args.pop
      else
        {}
      end
    end
  end
end
