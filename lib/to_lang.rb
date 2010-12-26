require File.expand_path("../to_lang/codemap", __FILE__)
require File.expand_path("../to_lang/connector", __FILE__)

module ToLang
  class << self
    attr_reader :connector

    def start(key)
      @connector = ToLang::Connector.new(key)
      String.send(:include, StringMethods)
      add_magic_methods
    end

    private

    def add_magic_methods
      String.class_eval do
        def method_missing(method, *args, &block)
          if method.to_s =~ /^to_(.*)$/ && CODEMAP[$1]
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
          if method.to_s =~ /^to_(.*)$/ && CODEMAP[$1]
            true
          else
            super
          end
        end
      end
    end
  end

  module StringMethods
    def translate(target, *args)
      ToLang.connector.request(self, target, *args)
    end
  end
end
