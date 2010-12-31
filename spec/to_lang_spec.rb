require 'spec_helper'

describe ToLang do
  describe ".start" do
    before :all do
      ToLang.start('apikey')
    end

    it "returns false if :start was already called" do
      ToLang.start('apikey').should == false
    end

    it "stores a ToLang::Connector object" do
      ToLang.connector.should be_an_instance_of ToLang::Connector
    end

    it "mixes StringMethods into String" do
      String.should include ToLang::StringMethods
    end
  end
end
