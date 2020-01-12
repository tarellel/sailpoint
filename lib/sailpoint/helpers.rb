# frozen_string_literal: true

# Used to override and give String the blank? validation similar to Rails
class String
  # Used to determine if the object is nil or empty ('')
  # @return [true, false]
  def blank?
    self.nil? || self.strip.empty? || self.strip.length.zero?
  end

  # Used to determine if the object is not nil
  # @return [true, false]
  def present?
    !self.nil?
  end

  def escape_str
    CGI.escape(self)
  end
end

# Used to printout a [Red] message to STDOUT in case you want to print a message without causing an Exception.
# @param msg [String] - The excpetion message that should be printed out
def print_exception(msg = '')
  puts "\e[31m#{msg}\e[0m"
end

# Similar to Rails imlemneation https://github.com/rails/rails/blob/66cabeda2c46c582d19738e1318be8d59584cc5b/activesupport/lib/active_support/core_ext/object/blank.rb#L56
class NilClass
  # Used to determine if the object is blank? || empty?
  # *Note:* If a nil value is specified it *should* always be blank? || empty?
  # @return [true, false]
  def blank?
    true
  end

  # Used to determine if the object is not nil
  # @return [true, false]
  def present?
    !blank?
  end
end

# Used to override and give Number the blank? validation similar to Rails
class Numeric
  # Used to determine if the object is blank? || empty?
  #
  # *Note:* If a object is declared a Numerica valye, it shouldn't ever be blank
  # @return [true, false]
  def blank?
    false
  end

  # Used to determine if the object is not nil
  # @return [true, false]
  def present?
    !blank?
  end
end

# Used to override and give Array the blank? validation similar to Rails
class Array
  # Used to determine if the object is blank? || empty?
  # @return [true, false]
  alias_method :blank?, :empty?
end

# Used to override and give Hash the blank? validation similar to Rails
class Hash
  alias_method :blank?, :empty?

  # Used to determine if the object is not nil
  # @return [true, false]
  def present?
    !blank?
  end
end

# Used to generate an Exception error hen invalid credentails have been supplied
class AuthenticationException < StandardError
  attr_reader :data

  # Used to generate an ExceptionError message when Authenication has failed
  # @param data [String] - The message in which you wish to send to STDOUT for the exception error
  def initialize(data = 'An API Authentication error has occured.')
    super
    @data = data
  end

  # Specify the attribute in which to push to STDOUT when generating a Ruby ExceptionError
  def message
    @data
  end
end