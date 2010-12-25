require 'spec_helper'

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
