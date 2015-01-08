require "spec_helper"

describe ToLang::Connector do
  let(:connector) { ToLang::Connector.new('apikey') }

  describe "custom query string normalizer" do
    it "returns a query string with unsorted parameters" do
      params = {
        :key_with_no_value => nil,
        :key => 'apikey',
        :target => 'es',
        :q => ["banana", "apple"]
      }
      expect(
        ToLang::Connector::UNSORTED_QUERY_STRING_NORMALIZER.call(params)
      ).to match(/q=banana&q=apple/)
    end
  end

  it "stores a key when initialized" do
    expect(connector.key).not_to be_nil
  end

  describe "#request" do
    # helper methods
    def stub_response(parsed_response)
      mock_response = double('HTTParty::Response', :parsed_response => parsed_response)
      allow(ToLang::Connector).to receive(:post).and_return(mock_response)
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
          expect(connector.request("hello world", "es")).to eq("hola mundo")
        end
      end

      context "with an ambiguous source language" do
        context "and no source language specified" do
          it "returns the same string" do
            stub_good_response "a pie"
            expect(connector.request("a pie", "es")).to eq("a pie")
          end
        end

        context "and a source language specified" do
          it "returns the translated string" do
            stub_good_response "un pastel"
            expect(connector.request("a pie", "es", :from => "en")).to eq("un pastel")
          end
        end
      end

      context "with a bad language pair" do
        it "raises an exception" do
          stub_bad_response "Bad language pair: en|en"
          expect { connector.request("a pie", "en", :from => "en") }.to raise_error(RuntimeError, "Bad language pair: en|en")
        end
      end

      context "when debugging the request" do
        it "returns the request URL" do
          expect(connector.request("hello world", "es", :from => "en", :debug => :request)).to eq({
            :key=> "apikey", :q => "hello world", :target => "es", :source => "en"
          })
        end
      end

      context "when debugging the response" do
        it "returns the full parsed response" do
          expected_response = stub_good_response("hola mundo")
          expect(
            connector.request("hello world", "es", :from => "en", :debug => :response)
          ).to eq(expected_response)
        end
      end

      context "when debugging the request and the response" do
        it "returns a hash with the request URL and the full parsed response" do
          expected_response = stub_good_response("hola mundo")
          output = connector.request("hello world", "es", :from => "en", :debug => :all)
          expect(output).to eq({
            :request => { :key=> "apikey", :q => "hello world", :target => "es", :source => "en" },
            :response => expected_response
          })
        end
      end
    end

    context "given an array of strings" do
      it "returns an array of translated strings" do
        stub_good_array_response ["hola", "mundo"]
        expect(connector.request(["hello", "world"], "es")).to eq(["hola", "mundo"])
      end
    end
  end
end
