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

describe "A string" do
  context "after ToLang has received :start" do
    before :all do
      ToLang.start('apikey')
    end

    it "responds to :translate" do
      String.new.should respond_to :translate
    end

    context "when sent :translate" do
      it "calls ToLang::Connector#request" do
        ToLang.connector.stub(:request)
        ToLang.connector.should_receive(:request).with("hello world", "es")
        "hello world".translate("es")
      end
    end

    ToLang::CODEMAP.each do |language, code|
      it "translates to #{language} when sent :to_#{language}" do
        ToLang.connector.stub(:request)
        ToLang.connector.should_receive(:request).with("hello world", code)
        "hello world".send("to_#{language}")
      end

      it "will then respond_to? :to_#{language}" do
        "hello_world".should respond_to "to_#{language}"
      end
    end
  end
end
