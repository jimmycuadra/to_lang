[![Gem Version](https://badge.fury.io/rb/to_lang.png)](http://badge.fury.io/rb/to_lang)
[![Build Status](https://travis-ci.org/jimmycuadra/to_lang.png?branch=master)](https://travis-ci.org/jimmycuadra/to_lang)
[![Code Climate](https://codeclimate.com/github/jimmycuadra/to_lang.png)](https://codeclimate.com/github/jimmycuadra/to_lang)

# to_lang

**to_lang** is a Ruby library that adds language translation methods to strings and arrays, backed by the Google Translate API.

## Installation

Simply run:

``` bash
gem install to_lang
```

## Usage

To use **to_lang**, require the library, then call `ToLang.start` with your Google Translate API key. At this point you will have access to all the new translation methods, which take the form `to_language`, where "language" is the language you wish to translate to.

Google Translate attempts to detect the source language, but you can specify it explicitly by calling methods in the form `to_target_language_from_source_language`, where "target language" is the language you are translating to and "source_language" is the language you are starting with. An inverted form with equivalent functionality, `from_source_language_to_target_language` is also available. These methods are generated dynamically and will not appear in a calls to `String.instance_methods` or `Array.instance_methods` until they have been called once. Strings and arrays will, however, `respond_to?` these methods prior to their dynamic definition.

The dynamic methods are simply syntactic sugar for `String#translate` and `Array#translate`, which you can use directly as well.

**to_lang** also comes with a command line utility for quick translations from the shell.

## String Examples

Load and initialize **to_lang**:

``` ruby
require 'to_lang'

ToLang.start('YOUR_GOOGLE_TRANSLATE_API_KEY')
```

Translate some text to Spanish:

``` ruby
"Very cool gem!".to_spanish # => "Muy fresco joya!"
```

A case where the source language is ambiguous:

``` ruby
"a pie".to_spanish # => "a pie"
"a pie".to_spanish_from_english # => "un pastel"
```

Or equivalently:

``` ruby
"a pie".from_english_to_spanish # => "un pastel"
```

Using `String#translate` directly:

``` ruby
"hello world".translate('es') # => "hola mundo"
"a pie".translate('es', :from => 'en') # => "un pastel"
```

## Array Examples

Arrays can be used to translate a batch of strings in a single method call and a single HTTP request. The exact same methods shown above work for arrays as well. For example, to translate an array of strings to Spanish:

``` ruby
["One", "Two", "Three"].to_spanish # => ["Uno", "Dos", "Tres"]
```

## Debugging

`translate` also has the advantage of allowing you to get debug output for a translation. `translate` accepts a `:debug` option with three possible values: `:request`, `:response`, and `:all`. `:request` will cause the method to return a hash of the parameters that will be sent to the Google Translate API. `:response` will cause the method to return the full response from the API call as a hash. `:all` will cause the method to return a hash which contains both the request hash and the full response.

``` ruby
"hello world".translate('es', :debug => :request)
# => {:key=>"my_key", :q=>"hello world", :target=>"es"}
```

``` ruby
"hello world".translate('es', :debug => :response)
# => {"data"=>{"translations"=>[{"translatedText"=>"hola mundo", "detectedSourceLanguage"=>"en"}]}}
```

``` ruby
"hello world".translate('es', :debug => :all)
# => {:request=>{:key=>"my_key", :q=>"hello world", :target=>"es"},
#    :response=>{"data"=>{"translations"=>[{"translatedText"=>"hola mundo",
#    "detectedSourceLanguage"=>"en"}]}}}
```

## Command Line Interface

The command line utility `to_lang` has the following interface:

```
to_lang [--key API_KEY] [--from SOURCE_LANGUAGE] --to DESTINATION_LANGUAGE STRING [STRING, ...]
```

`to_lang` accepts a space separated list of strings to translate. At least one string is required, as is the `--to` option, which accepts a language code (e.g. "es"). `to_lang` will attempt to load a Google Translate API key from the `GOOGLE_TRANSLATE_API_KEY` environment variable. If one is not available, it must be passed in from the command line with the `--key` option. For complete usage instructions, invoke the utility with the `--help` option.

Examples:

A simple translation with the key being passed in directly from the command line:

``` bash
to_lang --key YOUR_GOOGLE_TRANSLATE_API_KEY --to es "hello world"
hola mundo
```

With the key in an environment variable and multiple strings:

``` bash
to_lang --to es "hello world" "a pie"
hola mundo
a pie
```

Specifying the source language:

``` bash
to_lang --from en --to es "hello world" "a pie"
hola mundo
un pastel
```

## Supported Languages

**to_lang** adds the following methods to strings and arrays. Each of these methods can be called with an explicit source language by appending `_from_source_language` or prepending `from_source_language_` to the method name.

* to_afrikaans
* to_albanian
* to_arabic
* to_belarusian
* to_bulgarian
* to_catalan
* to_simplified_chinese
* to_traditional_chinese
* to_croatian
* to_czech
* to_danish
* to_dutch
* to_english
* to_estonian
* to_filipino
* to_finnish
* to_french
* to_galician
* to_german
* to_greek
* to_haitian_creole
* to_hebrew
* to_hindi
* to_hungarian
* to_icelandic
* to_indonesian
* to_irish
* to_italian
* to_japanese
* to_latvian
* to_lithuanian
* to_macedonian
* to_malay
* to_maltese
* to_norwegian
* to_persian
* to_polish
* to_portuguese
* to_romanian
* to_russian
* to_serbian
* to_slovak
* to_slovenian
* to_spanish
* to_swahili
* to_swedish
* to_thai
* to_turkish
* to_ukrainian
* to_vietnamese
* to_welsh
* to_yiddish

## Documentation

API documentation can be found at [rubydoc.info](http://rubydoc.info/github/jimmycuadra/to_lang/master/frames).

## Feedback and Contributions

Feedback is greatly appreciated. If you have any problems with **to_lang**, please open a new issue. Make sure you are using the latest version of the gem, or HEAD if you've cloned the Git repository directly. Please include debugging output from using the `:debug` option of `translate`, if relevant to your issue. If you'd like to fix bugs, add features, or improve the library in general, feel free to fork the project and send me a pull request with your changes.
