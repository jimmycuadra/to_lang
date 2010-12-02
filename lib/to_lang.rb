require File.expand_path("../to_lang/connector", __FILE__)

module ToLang
  def self.start(key)
    @@connector = ToLang::Connector.new(key)

    String.send(:include, InstanceMethods)
  end

  def self.connector
    @@connector
  end

  module InstanceMethods
    def translate(target, *args)
      ToLang.connector.request(self, target, *args)
    end
  end
end
