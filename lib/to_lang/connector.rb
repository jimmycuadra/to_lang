require 'rubygems'
require 'httparty'
require 'uri'

module ToLang
  class Connector
    API_URL = "https://www.googleapis.com/language/translate/v2"

    attr_reader :key

    def initialize(key)
      @key = key
    end

    def request(q, target, options = {})
      response = HTTParty.get request_url(q, target, options)
      raise response.parsed_response["error"]["message"] if response.parsed_response["error"] && response.parsed_response["error"]["message"]
      response.parsed_response["data"]["translations"][0]["translatedText"]
    end

    private

    def request_url(q, target, options)
      source = options[:from]
      url = "#{API_URL}?key=#{@key}&q=#{URI.escape(q)}&target=#{target}"
      url += "&source=#{source}" if source
      url
    end
  end
end
