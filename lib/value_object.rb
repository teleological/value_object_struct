
# The ValueObject module provides the ValueObject.class_with_attributes
# method for defining immutable value object classes based on ruby's
# Struct class.

module ValueObject

  # ValueObject.class_with_attributes accepts a list of member
  # attributes specified by Symbol and returns a Class that
  # inherits from a Struct class defined with those attributes.
  #
  # The constructors for the resulting class accepts a Hash of
  # attribute value assignments, unlike Struct class constructors
  # which expect an ordered list of attribute values. Attributes
  # must be specified by symbolic key. Undeclared attributes are
  # ignored.  Declared attributes of the value object which are
  # not explicitly initialized are set to the default value of the
  # initializing Hash (usually nil).
  #
  # Value object instances are Struct instances with private attribute
  # write access, including both named attribute writers and Hash or
  # Array style bracketed subscript assignment.

  def self.class_with_attributes(*attributes)
    Struct.new(*attributes).tap do |klass|
      klass.class_eval <<-"RUBY", __FILE__, __LINE__

        def initialize(attribute_hash={})
          attributes = members.map {|m| attribute_hash[m] }
          super(*attributes)
        end

        private :[]=

        private #{attributes.map {|attr| ":" + attr.to_s + "=" }.join(", ")}

      RUBY
    end
  end

end

