require "spec_helper"

describe "A ToLang-enabled string" do
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
    it "will respond_to :to_#{language}" do
      "hello world".should respond_to "to_#{language}"
    end

    it "will respond to :to_#{language}_from_english" do
      "hello world".should respond_to "to_#{language}_from_english"
    end

    it "will respond to :from_english_to_#{language}" do
      "hello world".should respond_to "from_english_to_#{language}"
    end

    it "translates to #{language} when sent :to_#{language}" do
      ToLang.connector.stub(:request)
      ToLang.connector.should_receive(:request).with("hello world", code)
      "hello world".send("to_#{language}")
    end

    it "translates to #{language} from english when sent :to_#{language}_from_english" do
      ToLang.connector.stub(:request)
      ToLang.connector.should_receive(:request).with("hello world", code, :from => 'en')
      "hello world".send("to_#{language}_from_english")
    end

    it "translates to #{language} from english went sent :from_english_to_#{language}" do
      ToLang.connector.stub(:request)
      ToLang.connector.should_receive(:request).with("hello world", code, :from => 'en')
      "hello world".send("from_english_to_#{language}")
    end
  end

  context "when a magic method has been called once" do
    before :each do
      ToLang.connector.stub(:request)
      "hello world".to_spanish
      "hello world".to_spanish_from_english
    end

    it "defines the method and does not call :method_missing the next time" do
      string = "hello world"
      string.should_not_receive(:method_missing)
      string.to_spanish
      string.to_spanish_from_english
    end
  end

  it "calls the original :method_missing if there is no language match in the first form" do
    expect { "hello world".to_foo }.to raise_error(NoMethodError)
  end

  it "calls the original :method_missing if there is a bad language match in the second form" do
    expect { "hello world".to_foo_from_bar }.to raise_error(NoMethodError)
  end

  it "calls the original :method_missing if there is a bad language match in the reversed second form" do
    expect { "hello world".from_bar_to_foo }.to raise_error(NoMethodError)
  end

  it "calls the original :method_missing if the method does not match either form" do
    expect { "hello world".foo }.to raise_error(NoMethodError)
  end
end
