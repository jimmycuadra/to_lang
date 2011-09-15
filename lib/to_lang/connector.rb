require 'httparty'
require 'cgi'
require "to_lang/core_ext"

module ToLang
  # Responsible for making the actual HTTP request to the Google Translate API.
  #
  class Connector
    include HTTParty

    # The base URL for all requests to the Google Translate API.
    #
    API_URL = "https://www.googleapis.com/language/translate/v2"

    # A custom query string normalizer that does not sort arguments. This is necessary to ensure that batch translations
    # are returned in the same order they appear in the input array.
    UNSORTED_QUERY_STRING_NORMALIZER = proc do |query|
      Array(query).map do |key, value|
        if value.nil?
          key
        elsif value.is_a?(Array)
          value.map {|v| "#{key}=#{URI.encode(v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"}
        else
          {key => value}.to_params
        end
      end.flatten.join('&')
    end
    query_string_normalizer UNSORTED_QUERY_STRING_NORMALIZER

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
    # @param [String, Array] q A string or array of strings to translate.
    # @param [String] target The language code for the language to translate to.
    # @param [Hash] options A hash of options.
    # @option options [String] :from The language code for the language of @q@.
    # @option options [Symbol] :debug Debug output to return instead of the translated string. Must be one of @:request@, @:response@, or @:all@.
    #
    # @raise [RuntimeError] If Google Translate returns any errors.
    # @return [String, Array, Hash] The translated string, an array of the translated strings, or debugging output, as requested.
    #
    def request(q, target, options = {})
      request_hash = { :key => @key, :q => q, :target => target }
      request_hash[:source] = options[:from] if options[:from]
      return request_hash if options[:debug] == :request

      response = self.class.post(API_URL, { :body => request_hash })
      return response.parsed_response if options[:debug] == :response
      return { :request => request_hash, :response => response.parsed_response } if options[:debug] == :all

      raise response.parsed_response["error"]["message"] if response.parsed_response["error"] && response.parsed_response["error"]["message"]

      translations = response.parsed_response["data"]["translations"]

      if translations.size > 1
        translations.map { |translation| CGI.unescapeHTML translation["translatedText"] }
      else
        CGI.unescapeHTML(translations[0]["translatedText"])
      end
    end
  end
end
