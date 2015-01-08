require 'spec_helper'

describe ToLang do
  describe ".start" do
    before :all do
      ToLang.start('apikey')
    end

    it "returns false if :start was already called" do
      expect(ToLang.start('apikey')).to be_falsy
    end

    it "stores a ToLang::Connector object" do
      expect(ToLang.connector).to be_an_instance_of(ToLang::Connector)
    end

    it "mixes Translatable into String" do
      expect(String).to include(ToLang::Translatable)
    end

    it "mixes Translatable into Array" do
      expect(Array).to include(ToLang::Translatable)
    end
  end
end
