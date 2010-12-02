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
    def translate(source, target)
      ToLang.connector.request(self, source, target)
    end
  end
end
