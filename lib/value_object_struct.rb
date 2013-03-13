
# The ValueObjectStruct module provides the
# ValueObjectStruct.class_with_attributes method for defining immutable
# value object classes based on ruby's Struct class.

module ValueObjectStruct

  # ValueObjectStruct.class_with_attributes accepts a list of member
  # attributes specified by Symbol and returns a Class that
  # inherits from a Struct class defined with those attributes.
  #
  # The constructor for the resulting class accepts a Hash of
  # attribute value assignments. Attributes must be specified by
  # symbolic key. Undeclared attributes are ignored. Declared
  # attributes of the value object which are not explicitly
  # initialized are set to the default value of the initializing
  # Hash (usually nil).
  #
  # The class also provides two factory methods: ::for_values, which
  # accepts an ordered list of attribute values like the Struct class
  # constructor, and ::value, which accepts a hash of attribute value
  # assignments, constructs the value object, and then freezes it
  # before returning it.
  #
  # Value object instances are Struct instances with private attribute
  # write access, including both named attribute writers and Hash or
  # Array style bracketed subscript assignment. If all attribute values
  # are nil, the value object is considered empty.

  def self.class_with_attributes(*attributes)
    Struct.new(*attributes).tap do |klass|
      klass.class_eval <<-"RUBY", __FILE__, __LINE__

        def self.value(attributes={})
          new(attributes).freeze
        end

        def initialize(attributes={})
          values = members.map { |m| attributes[m] }
          super(*values)
        end

        def self.for_values(*values)
          attributes = {}
          members.each_with_index { |m,i| attributes[m] = values[i] }
          new(attributes)
        end

        def empty?
          values.all?(&:nil?)
        end

        def attributes
          members.each_with_object({}) { |m,h| h[m.to_s] = self[m] }
        end

        alias_method :attribute, :[]

        private :[]=

        private #{attributes.map {|attr| ":" + attr.to_s + "=" }.join(", ")}

      RUBY
    end
  end

end

