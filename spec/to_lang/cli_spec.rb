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

  it "displays the version and exits with -v option" do
    $stdout.should_receive(:puts).with("ToLang v#{ToLang::VERSION}")
    expect {
      ToLang::CLI.start(["-v"])
    }.to raise_error(SystemExit)
  end

  it "displays the help screen and exits with -h option" do
    $stdout.should_receive(:puts).with(/Usage:/)
    expect {
      ToLang::CLI.start(["-h"])
    }.to raise_error(SystemExit)
  end

  it "requires a destination language" do
    expect {
      ToLang::CLI.start(["--key", "abc", "hello world"])
    }.to raise_error(SystemExit, /destination language/)
  end

  it "requires at least one string to translate" do
    expect {
      ToLang::CLI.start(["--key", "abc", "--to", "es"])
    }.to raise_error(SystemExit, /one string to translate/)
  end

  # it "extracts the strings to translate" do
  #   ToLang::CLI.start(["--key", "abc", "--to", "es", "--from", "en", "hello", "world"])
  #   ToLang::CLI.args.should == ["hello", "world"]
  # end
end
