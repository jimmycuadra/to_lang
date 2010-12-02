# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "to_lang/version"

Gem::Specification.new do |s|
  s.name        = "to_lang"
  s.version     = ToLang::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jimmy Cuadra"]
  s.email       = ["jimmy@jimmycuadra.com"]
  s.homepage    = "http://github.com/jimmycuadra/to_lang"
  s.summary     = %q{A Ruby client for the Google Translate API built directly into String}
  s.description = %q{A Ruby client for the Google Translate API built directly into String}

  s.rubyforge_project = "to_lang"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
