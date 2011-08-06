require "spec_helper"

describe ToLang::Connector do
  before :all do
    @connector = ToLang::Connector.new('apikey')
  end

  describe "custom query string normalizer" do
    it "returns a query string with unsorted parameters" do
      params = {
        :key_with_no_value => nil,
        :key => 'apikey',
        :target => 'es',
        :q => ["banana", "apple"]
      }
      ToLang::Connector::UNSORTED_QUERY_STRING_NORMALIZER.call(params).should =~ /q=banana&q=apple/
    end
  end

  it "stores a key when initialized" do
    @connector.key.should_not be_nil
  end

  describe "#request" do
    # helper methods
    def stub_response(parsed_response)
      mock_response = mock('HTTParty::Response', :parsed_response => parsed_response)
      ToLang::Connector.stub(:post).and_return(mock_response)
    end

    def stub_good_response(translated_text)
      parsed_response = { "data" => { "translations" => [ { "translatedText" => translated_text } ] } }
      stub_response(parsed_response)
      parsed_response
    end

    def stub_bad_response(error_message)
      parsed_response = { "error" => { "message" => error_message } }
      stub_response(parsed_response)
      parsed_response
    end

    def stub_good_array_response(translated_texts)
      parsed_response = { "data" => { "translations" => [] } }
      translated_texts.each { |text| parsed_response["data"]["translations"].push({ "translatedText" => text }) }
      stub_response(parsed_response)
      parsed_response
    end

    context "given a single string" do
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

      context "when debugging the request" do
        it "returns the request URL" do
          @connector.request("hello world", "es", :from => "en", :debug => :request).should == { :key=> "apikey", :q => "hello world", :target => "es", :source => "en" }
        end
      end

      context "when debugging the response" do
        it "returns the full parsed response" do
          expected_response = stub_good_response("hola mundo")
          @connector.request("hello world", "es", :from => "en", :debug => :response).should == expected_response
        end
      end

      context "when debugging the request and the response" do
        it "returns a hash with the request URL and the full parsed response" do
          expected_response = stub_good_response("hola mundo")
          output = @connector.request("hello world", "es", :from => "en", :debug => :all)
          output.should == { :request => { :key=> "apikey", :q => "hello world", :target => "es", :source => "en" }, :response => expected_response }
        end
      end
    end

    context "given an array of strings" do
      it "returns an array of translated strings" do
        stub_good_array_response ["hola", "mundo"]
        @connector.request(["hello", "world"], "es").should == ["hola", "mundo"]
      end
    end
  end
end
