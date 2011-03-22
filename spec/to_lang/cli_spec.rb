require "spec_helper"
require "to_lang/cli"

describe ToLang::CLI do
  before(:all) do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  before do
    ENV['GOOGLE_TRANSLATE_API_KEY'] = nil
  end

  it "requires an API key" do
    expect {
      ToLang::CLI.start([])
    }.to raise_error(SystemExit, /API key/)
  end

  it "accepts an API key from the command line" do
    expect {
      ToLang::CLI.start(["--key", "abc"])
    }.not_to raise_error(SystemExit, /API key/)
  end

  it "accepts an API key from the environment" do
    ENV['GOOGLE_TRANSLATE_API_KEY'] = "abc"
    expect {
      ToLang::CLI.start([])
    }.not_to raise_error(SystemExit, /API key/)
  end
end
