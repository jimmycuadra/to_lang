require "spec_helper"

describe "A translatable class" do
  before :all do
    ToLang.start('apikey')
  end

  describe "#translate" do
    it "calls ToLang::Connector#request" do
      expect(ToLang.connector).to receive(:request).with("hello world", "es")
      "hello world".translate("es")
    end
  end

  it "will respond to :to_<language>" do
    expect("hello world").to respond_to(:to_spanish)
  end

  it "will respond to :to_<target>_from_<source>" do
    expect("hello world").to respond_to(:to_spanish_from_english)
  end

  it "will respond to :from_<source>_to_<target>" do
    expect("hello world").to respond_to(:from_english_to_spanish)
  end

  it "translates to <language> when sent :to_<language>" do
    expect(ToLang.connector).to receive(:request).with("hello world", 'es')
    "hello world".send(:to_spanish)
  end

  it "translates to <target> from <source> when sent :to_<target>_from_<source>" do
    expect(ToLang.connector).to receive(:request).with("hello world", 'es', :from => 'en')
    "hello world".send(:to_spanish_from_english)
  end

  it "translates to <target> from <source> when sent :from_<source>_to_<target>" do
    expect(ToLang.connector).to receive(:request).with("hello world", 'es', :from => 'en')
    "hello world".send(:from_english_to_spanish)
  end

  it "defines magic methods when first called and doesn't call :method_missing after that" do
    allow(ToLang.connector).to receive(:request)
    string = "hello world"
    magic_methods = lambda do
      string.to_spanish
      string.to_spanish_from_english
      string.from_english_to_spanish
    end
    magic_methods.call
    expect(string).not_to receive(:method_missing)
    magic_methods.call
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
