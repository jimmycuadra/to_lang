require File.expand_path("../codemap", __FILE__)

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

    # Overrides @method_missing@ to catch and define dynamic translation methods.
    #
    # @private
    #
    def method_missing(method, *args, &block)
      case method.to_s
      when /^to_(.*)_from_(.*)$/
        if CODEMAP[$1] && CODEMAP[$2]
          new_method_name = "to_#{$1}_from_#{$2}".to_sym

          self.class.send(:define_method, new_method_name) do
            translate(CODEMAP[$1], :from => CODEMAP[$2])
          end

          return send(new_method_name)
        else
          super
        end
      when /^to_(.*)$/
        if CODEMAP[$1]
          new_method_name = "to_#{$1}".to_sym

          self.class.send(:define_method, new_method_name) do
            translate(CODEMAP[$1])
          end

          return send(new_method_name)
        else
          super
        end
      else
        super
      end
    end

    # Overrides @respond_to?@ to make strings aware of the dynamic translation methods.
    #
    # @private
    #
    def respond_to?(method, include_private = false)
      case method.to_s
      when /^to_(.*)_from_(.*)$/
        return true if CODEMAP[$1] && CODEMAP[$2]
      when /^to_(.*)$/
        return true if CODEMAP[$1]
      end

      super
    end
  end
end
