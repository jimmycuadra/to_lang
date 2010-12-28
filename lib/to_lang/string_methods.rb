module ToLang
  # The methods {ToLang} will mix into the String class when initialized.
  #
  module StringMethods
    # Translates a string to another language. All the magic methods use this internally. It, in turn, forwards
    # everything on to {ToLang::Connector#request}
    #
    # @param [String] target The language code for the language to translate to.
    # @param args Any additional arguments, such as the source language.
    #
    # @return [String] The translated string.
    #
    def translate(target, *args)
      ToLang.connector.request(self, target, *args)
    end
  end
end
