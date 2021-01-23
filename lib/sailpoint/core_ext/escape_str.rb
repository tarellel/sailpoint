# frozen_string_literal: true

require 'cgi'

class Object
  # In case anything other than a string is called with escape_str
  # @return [String]
  def escape_str
    ''
  end
end

class String
  # Escape any special characters to make them URL safe
  # @return [String]
  def escape_str
    CGI.escape(strip)
  end
end

class NilClass
  # If the identity value was never decalred
  # @return [String]
  def escape_str
    ''
  end
end
