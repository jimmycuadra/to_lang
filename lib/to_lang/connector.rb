require 'httparty'
require 'cgi'

module ToLang
  # Responsible for making the actual HTTP request to the Google Translate API.
  #
  class Connector
    # The base URL for all requests to the Google Translate API.
    #
    API_URL = "https://www.googleapis.com/language/translate/v2"

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
    end

    # Makes a request to the Google Translate API.
    #
    # @param [String] q The string to translate.
    # @param [String] target The language code for the language to translate to.
    # @param [Hash] options A hash of options.
    # @option options [String] :from The language code for the language of @q@.
    # @option options [Symbol] :debug Debug output to return instead of the translated string. Must be one of @:request@, @:response@, or @:all@.
    #
    # @raise [RuntimeError] Raises an exception for any errors returned by Google Translate.
    # @return [String, Hash] The translated string or debugging output, as requested.
    #
    def request(q, target, options = {})
      request = request_url(q, target, options)
      return request if options[:debug] == :request

      response = HTTParty.get request_url(q, target, options)
      return { :request => request, :response => response.parsed_response } if options[:debug] == :all
      return response.parsed_response if options[:debug] == :response

      raise response.parsed_response["error"]["message"] if response.parsed_response["error"] && response.parsed_response["error"]["message"]
      CGI.unescapeHTML(response.parsed_response["data"]["translations"][0]["translatedText"])
    end

    private

    # Constructs the URL that will be used by {#request}.
    #
    # @param [String] q The string to translate.
    # @param [String] target The language code for the language to translate to.
    # @param [Hash] options A hash of options.
    # @option options [String] :from The language code for the language of @q@.
    #
    # @return [String] The URL to request for the API call.
    #
    def request_url(q, target, options)
      source = options[:from]
      url = "#{API_URL}?key=#{@key}&q=#{CGI.escape(q)}&target=#{target}"
      url += "&source=#{source}" if source
      url
    end
  end
end
