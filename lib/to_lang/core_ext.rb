# Hash extensions taken from John Nunemaker's Crack gem.
#
# Crack was previously a dependency for HTTParty, but since it
# no longer is, the methods being used by {ToLang} are included
# here directly.
#
class Hash
  # Convert the entire has into a string suitable for HTTP requests.
  #
  # @return [String] This hash as a query string.
  #
  def to_params
    params = self.map { |k,v| normalize_param(k,v) }.join
    params.chop! # trailing &
    params
  end

  # Turns a key value pair into a string suitable for HTTP requests.
  #
  # @param [Object] key The key for the param.
  # @param [Object] value The value for the param.
  #
  # @return [String] This key value pair as a param
  #
  def normalize_param(key, value)
    param = ''
    stack = []

    if value.is_a?(Array)
      param << value.map { |element| normalize_param("#{key}[]", element) }.join
    elsif value.is_a?(Hash)
      stack << [key,value]
    else
      param << "#{key}=#{URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}&"
    end

    stack.each do |parent, hash|
      hash.each do |key, value|
        if value.is_a?(Hash)
          stack << ["#{parent}[#{key}]", value]
        else
          param << normalize_param("#{parent}[#{key}]", value)
        end
      end
    end

    param
  end
end
