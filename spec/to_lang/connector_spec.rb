require "spec_helper"

describe ToLang::Connector do
  before :all do
    @connector = ToLang::Connector.new('apikey')
  end

  it "stores a key when initialized" do
    @connector.key.should_not be_nil
  end

  describe "#request" do
    def stub_response(parsed_response)
      mock_response = mock('HTTParty::Response', :parsed_response => parsed_response)
      HTTParty.stub(:get).and_return(mock_response)
    end

    def stub_good_response(translated_text)
      parsed_response = { "data" => { "translations" => [ { "translatedText" => translated_text } ] } }
      stub_response(parsed_response)
    end

    def stub_bad_response(error_message)
      parsed_response = { "error" => { "message" => error_message } }
      stub_response(parsed_response)
    end

    context "with only a target language" do
      it "returns the translated string" do
        stub_good_response "hola mundo"
        @connector.request("hello world", "es").should == "hola mundo"
      end
    end

    context "with an ambiguous source language" do
      context "and no source language specified" do
        it "returns the same string" do
          stub_good_response "a pie"
          @connector.request("a pie", "es").should == "a pie"
        end
      end

      context "and a source language specified" do
        it "returns the translated string" do
          stub_good_response "un pastel"
          @connector.request("a pie", "es", :from => "en").should == "un pastel"
        end
      end
    end

    context "with a bad language pair" do
      it "raises an exception" do
        stub_bad_response "Bad language pair: en|en"
        expect { @connector.request("a pie", "en", :from => "en") }.to raise_error(RuntimeError, "Bad language pair: en|en")
      end
    end
  end
end
