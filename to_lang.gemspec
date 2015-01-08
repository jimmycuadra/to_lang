# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "to_lang/version"

Gem::Specification.new do |s|
  s.name        = "to_lang"
  s.version     = ToLang::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jimmy Cuadra"]
  s.email       = ["jimmy@jimmycuadra.com"]
  s.homepage    = "https://github.com/jimmycuadra/to_lang"
  s.summary     = %q{Translate strings with Google Translate}
  s.description = %q{Adds language translation methods to strings and arrays, backed by the Google Translate API}
  s.rubyforge_project = s.name
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httparty", ">= 0.8.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", ">= 3.1.0"
  s.add_development_dependency "simplecov", ">= 0.5.3"
end
