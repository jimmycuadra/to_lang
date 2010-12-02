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

    def request(q, source, target)
      encoded_q = URI.escape(q)
      response = self.class.get "#{API_URL}?key=#{@key}&q=#{encoded_q}&source=#{source}&target=#{target}"
      response.parsed_response["data"]["translations"][0]["translatedText"]
    end
  end
end
