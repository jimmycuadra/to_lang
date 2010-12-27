# -*- encoding: utf-8 -*-
require File.expand_path("../lib/to_lang/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "to_lang"
  s.version     = ToLang::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jimmy Cuadra"]
  s.email       = ["jimmy@jimmycuadra.com"]
  s.homepage    = "https://github.com/jimmycuadra/to_lang"
  s.summary     = %q{A Ruby client for the Google Translate API built directly into String}
  s.description = %q{A Ruby client for the Google Translate API built directly into String}
  s.rubyforge_project = s.name
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httparty", "~> 0.6"
  s.add_development_dependency "bundler", "~> 1.0"
  s.add_development_dependency "rake", "~> 0.8"
  s.add_development_dependency "rspec", "~> 2.3"
  s.add_development_dependency "simplecov", "~> 0.3"
  s.add_development_dependency "yard", "~> 0.6"
end
