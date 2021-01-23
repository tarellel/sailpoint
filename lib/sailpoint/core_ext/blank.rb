# frozen_string_literal: true

unless defined?(Object.blank?)
  class Object
    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end

    def present?
      !blank?
    end
  end

  # Used to override and give String the blank? validation similar to Rails
  class String
    # Used to determine if the object is nil or empty ('')
    # @return [Boolean]
    def blank?
      strip&.empty? || strip&.length&.zero?
    end
  end

  # Similar to Rails imlemneation https://github.com/rails/rails/blob/66cabeda2c46c582d19738e1318be8d59584cc5b/activesupport/lib/active_support/core_ext/object/blank.rb#L56
  class NilClass
    # Used to determine if the object is blank? || empty?
    # *Note:* If a nil value is specified it *should* always be blank? || empty?
    # @return [Boolean]
    def blank?
      true
    end
  end

  # Used to override and give Number the blank? validation similar to Rails
  class Numeric
    # Used to determine if the object is blank? || empty?
    #
    # *Note:* If a object is declared a Numerica valye, it shouldn't ever be blank
    # @return [Boolean]
    def blank?
      false
    end
  end

  # Used to override and give Array the blank? validation similar to Rails
  class Array
    # Used to determine if the object is blank? || empty?
    # @return [Boolean]
    alias blank? empty?
  end

  # Used to override and give Hash the blank? validation similar to Rails
  class Hash
    alias blank? empty?
  end
end
