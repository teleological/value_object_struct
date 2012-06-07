
require 'spec_helper'

describe ValueObject do

  let(:object_class) { ValueObject.class_with_attributes(:foo,:baz) }

  describe ".class_with_attributes" do

    it "defines a Struct subclass" do
      object_class.superclass.should be Struct
    end

    it "declares the given members" do
      object_class.members.should == [:foo,:baz]
    end

  end

  context "as a Struct subclass" do

    context "initialized with a hash" do

      it "initializes members from named argument" do
        instance = object_class.new(foo: "bar", baz: "qux")
        instance[:foo].should == "bar"
        instance.baz.should == "qux"
      end

      it "leaves members omitted from constructor hash nil" do
        instance = object_class.new(foo: "bar")
        instance.baz.should be_nil
      end

    end

    context "initialized without arguments" do

      it "returns a null object" do
        instance = object_class.new()
        instance.members.each {|m| instance[m].should be_nil}
      end

    end

    describe ".for_values" do

      it "initializes attributes in members order" do
        instance = object_class.for_values("bar","qux")
        instance[:foo].should == "bar"
        instance.baz.should == "qux"
      end

      context "without arguments" do

        it "returns a null object" do
          instance = object_class.for_values
          instance.members.each {|m| instance[m].should be_nil}
        end

      end

    end

    context "given an instance" do

      let(:instance) { object_class.new(foo: "bar") }

      it "privatizes member setters" do
        lambda { instance.bar = "quxx" }.should raise_error(NoMethodError)
      end

      it "privatizes hash write access" do
        lambda { instance[:bar] = "quxx" }.should raise_error(NoMethodError)
      end

    end

  end

end

