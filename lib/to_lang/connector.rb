require 'httparty'
require 'cgi'

module ToLang
  # Responsible for making the actual HTTP request to the Google Translate API.
  #
  class Connector
    include HTTParty

    # The base URL for all requests to the Google Translate API.
    #
    API_URL = "https://www.googleapis.com/language/translate/v2"

    # The maximum number of characters the string to translate can be.
    #
    MAX_STRING_LENGTH = 5000

    # The Google Translate API key to use when making API calls.
    #
    # @return [String] The Google Translate API key.
    #
    attr_reader :key

    # Initializes a new {ToLang::Connector} and stores a Google Translate API key.
    #
    # @return [ToLang::Connector] The new {ToLang::Connector} instance.
    def initialize(key)
      @key = key
      self.class.headers "X-HTTP-Method-Override" => "GET"
    end

    # Makes a request to the Google Translate API.
    #
    # @param [String] q The string to translate.
    # @param [String] target The language code for the language to translate to.
    # @param [Hash] options A hash of options.
    # @option options [String] :from The language code for the language of @q@.
    # @option options [Symbol] :debug Debug output to return instead of the translated string. Must be one of @:request@, @:response@, or @:all@.
    #
    # @raise [RuntimeError] If the string is too long or if Google Translate returns any errors.
    # @return [String, Hash] The translated string or debugging output, as requested.
    #
    def request(q, target, options = {})
      raise "The string to translate cannot be greater than #{MAX_STRING_LENGTH} characters" if q.size > MAX_STRING_LENGTH

      request_hash = { :key => @key, :q => q, :target => target }
      request_hash[:source] = options[:from] if options[:from]
      return request_hash if options[:debug] == :request

      response = self.class.post(API_URL, { :body => request_hash })
      return response.parsed_response if options[:debug] == :response
      return { :request => request_hash, :response => response.parsed_response } if options[:debug] == :all

      raise response.parsed_response["error"]["message"] if response.parsed_response["error"] && response.parsed_response["error"]["message"]
      CGI.unescapeHTML(response.parsed_response["data"]["translations"][0]["translatedText"])
    end
  end
end
