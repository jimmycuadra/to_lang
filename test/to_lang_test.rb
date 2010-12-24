$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'test/unit'
require 'to_lang'

class ToLang::ToLangTest < Test::Unit::TestCase
  def test_connector_should_not_exist_before_calling_start
    assert_nil ToLang.connector
  end

  def test_start_should_initialize_connector
    ToLang.start('abcdefg')
    assert_equal ToLang.connector.class, ToLang::Connector
  end

  def test_start_should_include_instance_methods_in_string
    ToLang.start('abcdefg')
    assert String.include? ::ToLang::InstanceMethods
    assert_respond_to 'test string', :translate
  end
end
