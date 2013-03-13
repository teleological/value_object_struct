
require 'spec_helper'

describe ValueObjectStruct do

  let(:struct_class) { ValueObjectStruct.class_with_attributes(:foo,:baz) }

  describe ".class_with_attributes" do

    it "defines a Struct subclass" do
      struct_class.superclass.should be Struct
    end

    it "declares the given members" do
      struct_class.members.should == [:foo,:baz]
    end

  end

  context "as a Struct subclass" do

    context "initialized with a hash" do

      it "initializes members from named argument" do
        instance = struct_class.new(foo: "bar", baz: "qux")
        instance[:foo].should == "bar"
        instance.baz.should == "qux"
      end

      it "leaves members omitted from constructor hash nil" do
        instance = struct_class.new(foo: "bar")
        instance.baz.should be_nil
      end

    end

    context "initialized without arguments" do

      it "returns a null object" do
        instance = struct_class.new()
        instance.members.each {|m| instance[m].should be_nil}
      end

    end

    describe ".for_values" do

      it "initializes attributes in members order" do
        instance = struct_class.for_values("bar","qux")
        instance[:foo].should == "bar"
        instance.baz.should == "qux"
      end

      context "without arguments" do

        it "returns a null object" do
          instance = struct_class.for_values
          instance.members.each {|m| instance[m].should be_nil}
        end

      end

    end

    describe ".value" do

      it "initializes members from named argument" do
        instance = struct_class.value(foo: "bar", baz: "qux")
        instance[:foo].should == "bar"
        instance.baz.should == "qux"
      end

      it "returns a frozen object" do
        struct_class.value(foo: "bar", baz: "qux").should be_frozen
      end

    end

    context "given an instance" do

      let(:instance) { struct_class.new(foo: "bar") }

      it "privatizes member setters" do
        lambda { instance.bar = "quxx" }.
          should raise_error(NoMethodError)
      end

      it "privatizes hash write access" do
        lambda { instance[:bar] = "quxx" }.
          should raise_error(NoMethodError)
      end

      it "provides #attributes hash" do
        instance.attributes.should == { "foo" => "bar", "baz" => nil }
      end

      it "provides #attribute alias" do
        instance.attribute(:foo).should == "bar"
      end

    end

    context "given an instance without initialized attributes" do

      let(:instance) { struct_class.new() }

      it "is considered empty" do
        instance.should be_empty
      end

    end

  end

end

