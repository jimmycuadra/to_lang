# -*- encoding: utf-8 -*-
require File.expand_path("../lib/to_lang/version", __FILE__)

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

  s.add_dependency "httparty", "~> 0.7.0"
  s.add_development_dependency "bundler", "~> 1.0.10"
  s.add_development_dependency "rake", "~> 0.8.7"
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "simplecov", "~> 0.4.1"
  s.add_development_dependency "yard", "~> 0.6.5"
  s.add_development_dependency "RedCloth", "~> 4.2.7"
  s.add_development_dependency "guard-rspec", "~> 0.2.0"
  s.add_development_dependency "rb-fsevent", "~> 0.4.0" if RUBY_PLATFORM[/darwin/]
  s.add_development_dependency "growl", "~> 1.0.3" if RUBY_PLATFORM[/darwin/]
end
