require "slop"

module ToLang
  module CLI
    class << self
      attr_accessor :args, :options

      def start(argv)
        self.args = argv
        parse_options!
        require "to_lang"
        ToLang.start(options[:key])
        puts args.translate(options[:to], :from => options[:from])
      end

      private

      def parse_options!
        self.options = Slop.new do
          banner "Usage: to_lang [--key API_KEY] [--from SOURCE_LANGUAGE] --to DESTINATION_LANGUAGE STRING [STRING, ...]"
          on :k, :key, "A Google Translate API key (Will attempt to use ENV['GOOGLE_TRANSLATE_API_KEY'] if not supplied)", true, :default => ENV['GOOGLE_TRANSLATE_API_KEY']
          on :t, :to, "The destination language", true
          on :f, :from, "The source language", :optional => true
          on :v, :version, "The current version of ToLang" do
            require "to_lang/version"
            puts "ToLang v#{ToLang::VERSION}"
            exit
          end
          on :h, :help, "Print this help message" do
            puts help
            exit
          end
        end

        self.options.parse! args

        abort "A Google Translate API key is required" unless options[:key]
        abort "A valid destination language is required" unless options[:to]
        abort "At least one string to translate is required" unless args.size >= 1
      end
    end
  end
end
