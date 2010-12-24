require File.expand_path("../to_lang/connector", __FILE__)

module ToLang
  class << self
    attr_reader :connector

    def start(key)
      @connector = ToLang::Connector.new(key)
      String.send(:include, InstanceMethods)
    end
  end

  module InstanceMethods
    def translate(target, *args)
      ToLang.connector.request(self, target, *args)
    end
  end
end
