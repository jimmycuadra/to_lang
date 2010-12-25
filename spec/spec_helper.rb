require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require File.expand_path('../../lib/to_lang', __FILE__)
