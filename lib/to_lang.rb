require File.expand_path("../to_lang/codemap", __FILE__)
require File.expand_path("../to_lang/connector", __FILE__)
require File.expand_path("../to_lang/string_methods", __FILE__)

# {ToLang} is a Ruby library that adds language translation methods to strings, backed by the Google Translate API.
#
# @author Jimmy Cuadra
# @see https://github.com/jimmycuadra/to_lang Source on GitHub
#
module ToLang
  class << self
    # A {ToLang::Connector} object to use for translation requests.
    #
    # @return [ToLang::Constructor, NilClass] An initialized {ToLang::Connector connector} or nil.
    attr_reader :connector

    # Initializes {ToLang}, after which the translation methods will be available from strings.
    #
    # @param [String] key A Google Translate API key.
    #
    # @return [Boolean] True if initialization succeeded, false if this method has already been called successfully.
    #
    def start(key)
      return false if defined?(@connector) && !@connector.nil?
      @connector = ToLang::Connector.new(key)
      String.send(:include, StringMethods)
      true
    end
  end
end
