require File.expand_path('../../spec_helper', __FILE__)

describe ToLang::Connector do
  it "stores a key when initialized" do
    connector = ToLang::Connector.new('apikey')
    connector.key.should_not be_nil
  end
end
