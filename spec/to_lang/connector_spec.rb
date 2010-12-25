require File.expand_path('../../spec_helper', __FILE__)

describe ToLang::Connector do
  before :all do
    @connector = ToLang::Connector.new('apikey')
  end

  it "stores a key when initialized" do
    @connector.key.should_not be_nil
  end

  context "when sent :request" do
    def stub_response(response_text)
      parsed_response = { "data" => { "translations" => [ { "translatedText" => response_text } ] } }
      mock_response = mock('HTTParty::Response', :parsed_response => parsed_response)
      HTTParty.stub(:get).and_return(mock_response)
    end

    context "with only a target language" do
      it "returns the translated string" do
        stub_response "hola mundo"
        @connector.request("hello world", "es").should == "hola mundo"
      end
    end

    context "with an ambiguous source language" do
      context "and no source language specified" do
        it "returns the same string" do
          stub_response "a pie"
          @connector.request("a pie", "es").should == "a pie"
        end
      end

      context "and a source language specified" do
        it "returns the translated string" do
          stub_response "un pastel"
          @connector.request("a pie", "es", :from => "en").should == "un pastel"
        end
      end
    end
  end
end
