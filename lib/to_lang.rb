require File.expand_path("../to_lang/codemap", __FILE__)
require File.expand_path("../to_lang/connector", __FILE__)

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
      add_magic_methods
      true
    end

    private

    # Adds dynamic methods to strings by overriding @method_missing@ and @respond_to?@.
    #
    def add_magic_methods
      String.class_eval do
        def method_missing(method, *args, &block)
          if method.to_s =~ /^to_(.*)_from_(.*)$/ && CODEMAP[$1] && CODEMAP[$2]
            new_method_name = "to_#{$1}_from_#{$2}".to_sym

            self.class.send(:define_method, new_method_name, Proc.new {
              translate(CODEMAP[$1], :from => CODEMAP[$2])
            })

            send new_method_name
          elsif method.to_s =~ /^to_(.*)$/ && CODEMAP[$1]
            new_method_name = "to_#{$1}".to_sym

            self.class.send(:define_method, new_method_name, Proc.new {
              translate(CODEMAP[$1])
            })

            send new_method_name
          else
            super
          end
        end

        def respond_to?(method, include_private = false)
          if method.to_s =~ /^to_(.*)_from_(.*)$/ && CODEMAP[$1] && CODEMAP[$2]
            true
          elsif method.to_s =~ /^to_(.*)$/ && CODEMAP[$1]
            true
          else
            super
          end
        end
      end
    end
  end

  # The methods {ToLang} will mix into the String class when initialized.
  #
  module StringMethods
    # Translates a string to another language. All the magic methods use this internally. It, in turn, forwards
    # everything on to {ToLang::Connector#request}
    #
    # @param [String] target The language code for the language to translate to.
    # @param args Any additional arguments, such as the source language.
    #
    # @return [String] The translated string.
    #
    def translate(target, *args)
      ToLang.connector.request(self, target, *args)
    end
  end
end
