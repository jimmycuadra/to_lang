require 'spec_helper'

describe ToLang do
  context "when sent :start" do
    before :all do
      ToLang.start('apikey')
    end

    it "stores a ToLang::Connector object" do
      ToLang.connector.should be_an_instance_of ToLang::Connector
    end

    it "mixes StringMethods into String" do
      String.should include ToLang::StringMethods
    end
  end
end

describe "An instance of String" do
  context "after ToLang has received :start" do
    before :all do
      ToLang.start('apikey')
    end

    it "responds to :translate" do
      String.new.should respond_to :translate
    end
  end
end
