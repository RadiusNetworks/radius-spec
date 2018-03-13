# frozen_string_literal: true

require 'radius/spec/model_factory'

RSpec.describe Radius::Spec::ModelFactory do
  before do
    Radius::Spec::ModelFactory.templates.clear
  end

  it "loads 'spec/support/model_factories.rb' by default" do
    expect(TEMP_SPEC_LOAD_CHECK).to eq true
  end

  describe "defining a factory", "through the module" do
    it "supports the explicit `define_factory` and shorter `factory` APIs" do
      expect {
        Radius::Spec::ModelFactory.define_factory("AnyClass")
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")

      expect {
        Radius::Spec::ModelFactory.factory("AnotherClass")
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnotherClass")
    end

    it "supports registering class names as strings" do
      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")
    end

    it "supports registering class names as symbols" do
      expect {
        Radius::Spec::ModelFactory.factory(
          :AnyClass,
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")
    end

    it "supports registering class constants" do
      stub_const "AnyClass", Struct.new(:arg1, :arg2, keyword_init: true)

      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")
    end

    it "registers the attributes to the class" do
      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to(
        "AnyClass" => {
          arg1: "Any Value",
          arg2: "Any Other Value",
        }
      )
    end

    it "replaces any existing attributes for the class" do
      Radius::Spec::ModelFactory.factory(
        "AnyClass",
        arg1: "Any Value",
        arg2: "Any Other Value",
      )

      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Updated Value",
          arg2: "Updated Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.from(
        "AnyClass" => {
          arg1: "Any Value",
          arg2: "Any Other Value",
        }
      ).to(
        "AnyClass" => {
          arg1: "Updated Value",
          arg2: "Updated Other Value",
        }
      )
    end

    it "duplicates the registered attribute hash", :aggregate_failures do
      orig_attrs = {
        arg1: "Any Value",
        arg2: "Any Other Value",
      }
      Radius::Spec::ModelFactory.factory "AnyClass", orig_attrs

      registered_attrs = Radius::Spec::ModelFactory.templates["AnyClass"]
      expect(registered_attrs).to eq orig_attrs
      expect(registered_attrs).not_to be orig_attrs
      expect {
        orig_attrs[:arg1] = "Updated Value"
      }.not_to change {
        Radius::Spec::ModelFactory.templates["AnyClass"]
      }.from(
        arg1: "Any Value",
        arg2: "Any Other Value",
      )
    end

    it "freezes the registered attribute hash to prevent modification" do
      Radius::Spec::ModelFactory.factory "AnyClass", arg1: "Any Value"
      expect(Radius::Spec::ModelFactory.templates["AnyClass"]).to be_frozen
    end

    it "symbolizes attribute names" do
      expect {
        Radius::Spec::ModelFactory.factory(
          :AnyClass,
          "arg1" => "Any Value",
          "arg2" => "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to(
        "AnyClass" => {
          arg1: "Any Value",
          arg2: "Any Other Value",
        }
      )
    end
  end

  describe "defining a factory", "via the catalog" do
    it "yields the catalog" do
      expect { |b|
        Radius::Spec::ModelFactory.catalog(&b)
      }.to yield_with_args(Radius::Spec::ModelFactory)
    end
  end

  specify "building an instance which is not registered " \
          "raises `TemplateNotFound`" do
    expect {
      Radius::Spec::ModelFactory.build "AnyClass"
    }.to raise_error(
      Radius::Spec::ModelFactory::TemplateNotFound,
      "template not found: AnyClass",
    )
  end

  specify "building an instance for a non-existant class raises `NameError`" do
    Radius::Spec::ModelFactory.define_factory "AnyClass"
    expect {
      Radius::Spec::ModelFactory.build "AnyClass"
    }.to raise_error NameError, "uninitialized constant AnyClass"
  end

  describe "building an instance" do
    it "does not require custom attributes" do
      stub_const "AnyClass", Struct.new(:arg1, :arg2, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory(
        "AnyClass",
        arg1: "Any Default Arg1 Value",
        arg2: "Any Default Arg2 Value",
      )

      an_instance = Radius::Spec::ModelFactory.build("AnyClass")
      expect(an_instance).to be_an_instance_of(AnyClass).and have_attributes(
        arg1: "Any Default Arg1 Value",
        arg2: "Any Default Arg2 Value",
      )
    end

    it "merges the custom attributes with the registered ones" do
      stub_const "AnyClass", Struct.new(:arg1, :arg2, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory(
        "AnyClass",
        arg1: "Any Default Arg1 Value",
        arg2: "Any Default Arg2 Value",
      )

      an_instance = Radius::Spec::ModelFactory.build(
        "AnyClass",
        arg1: "Custom Value",
      )
      expect(an_instance).to be_an_instance_of(AnyClass).and have_attributes(
        arg1: "Custom Value",
        arg2: "Any Default Arg2 Value",
      )

      an_instance = Radius::Spec::ModelFactory.build(
        "AnyClass",
        arg2: "Custom Value",
      )
      expect(an_instance).to be_an_instance_of(AnyClass).and have_attributes(
        arg1: "Any Default Arg1 Value",
        arg2: "Custom Value",
      )
    end

    it "includes custom attributes which were not registered" do
      stub_const "AnyClass", Struct.new(:arg1, :arg2, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory(
        "AnyClass",
        arg1: "Any Default Arg1 Value",
      )
      an_instance = Radius::Spec::ModelFactory.build(
        "AnyClass",
        arg2: "Custom Value",
      )

      expect(an_instance).to be_an_instance_of(AnyClass).and have_attributes(
        arg1: "Any Default Arg1 Value",
        arg2: "Custom Value",
      )
    end

    it "duplicates registered attributes to prevent state leak " \
       "between instances", :aggregate_failures do
      mutable_array = %i[any value]
      stub_const "AnyClass", Struct.new(:arr, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass", arr: mutable_array
      an_instance = Radius::Spec::ModelFactory.build("AnyClass")
      another_instance = Radius::Spec::ModelFactory.build("AnyClass")

      aggregate_failures "produces expected values" do
        expect(an_instance.arr).to eq mutable_array
        expect(another_instance.arr).to eq mutable_array
      end

      aggregate_failures "values are duplicates" do
        expect(an_instance.arr).not_to be mutable_array
        expect(another_instance.arr).not_to be mutable_array
      end

      expect {
        an_instance.arr << :modification
      }.not_to change {
        another_instance.arr
      }.from(mutable_array)
    end

    it "does not duplicate frozen registered attributes" do
      frozen_array = %i[any value].freeze
      stub_const "AnyClass", Struct.new(:arr, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass", arr: frozen_array
      an_instance = Radius::Spec::ModelFactory.build("AnyClass")

      expect(an_instance.arr).to be frozen_array
    end

    it "does not duplicate custom attributes", :aggregate_failures do
      stub_const "AnyClass", Struct.new(:arr, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass", arr: nil
      shared_array = %i[any value]
      an_instance = Radius::Spec::ModelFactory.build(
        "AnyClass",
        arr: shared_array,
      )
      another_instance = Radius::Spec::ModelFactory.build(
        "AnyClass",
        arr: shared_array,
      )

      aggregate_failures "values are not duplicates" do
        expect(an_instance.arr).to be shared_array
        expect(another_instance.arr).to be shared_array
      end

      expect {
        shared_array << :modification
      }.to change {
        an_instance.arr
      }.to(
        %i[any value modification]
      ).and change {
        another_instance.arr
      }.to(
        %i[any value modification]
      )
    end

    it "transforms registered attribute generators", :aggregate_failures do
      counter = 0
      stub_const "AnyClass", Struct.new(:arg, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass",
                                                arg: -> { counter += 1 }
      expect {
        Radius::Spec::ModelFactory.build "AnyClass"
      }.to change {
        counter
      }.from(0).to(1)

      expect {
        expect(Radius::Spec::ModelFactory.build("AnyClass").arg).to eq 2
      }.to change {
        counter
      }.from(1).to(2)
    end

    it "does not transform other objects which respond to call" do
      non_proc_callable = double("Callable")
      allow(non_proc_callable).to receive(:dup).and_return(non_proc_callable)
      allow(non_proc_callable).to receive(:call).and_raise(
        ":call was called on a non-Proc object"
      )
      stub_const "AnyClass", Struct.new(:arg, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass",
                                                arg: non_proc_callable
      an_instance = Radius::Spec::ModelFactory.build("AnyClass")

      expect(an_instance.arg).to be non_proc_callable
    end

    it "does not transform custom attribute procs" do
      non_proc_callable = double("Callable")
      allow(non_proc_callable).to receive(:call).and_raise(
        ":call was called on a non-Proc object"
      )
      stub_const "AnyClass", Struct.new(:arg, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass",
                                                arg: non_proc_callable
      an_instance = Radius::Spec::ModelFactory.build(
        "AnyClass",
        arg: non_proc_callable,
      )

      expect(an_instance.arg).to be non_proc_callable
    end

    it "does not transform replaced registered attribute generators" do
      counter = 0
      stub_const "AnyClass", Struct.new(:arg, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass",
                                                arg: -> { counter += 1 }
      expect {
        Radius::Spec::ModelFactory.build "AnyClass", arg: :anything
      }.not_to change {
        counter
      }.from(0)
    end

    it "removes optional registered attributes" do
      stub_const "AnyClass", Struct.new(:arg, keyword_init: true)
      Radius::Spec::ModelFactory.define_factory "AnyClass",
                                                arg: :optional

      an_instance = Radius::Spec::ModelFactory.build("AnyClass")
      expect(an_instance.arg).to be nil

      an_instance = Radius::Spec::ModelFactory.build("AnyClass", arg: :custom)
      expect(an_instance.arg).to eq :custom
    end

    it "pass any provided block to the object's initializer" do
      block_initialized = false
      stub_const(
        "AnyClass",
        Class.new {
          def initialize(*)
            yield
          end
        },
      )
      Radius::Spec::ModelFactory.define_factory "AnyClass"

      expect {
        Radius::Spec::ModelFactory.build("AnyClass") do
          block_initialized = true
        end
      }.to change {
        block_initialized
      }.to true
    end
  end

  describe "creating an instance" do
    it "builds the instance based on the template and custom attributes",
       :aggregate_failures do
      counter = 0
      block_initialized = false
      stub_const(
        "AnyClass",
        Struct.new(:arg1, :arg2, :arg3, keyword_init: true) {
          def initialize(*)
            super
            yield self
          end
        },
      )
      Radius::Spec::ModelFactory.define_factory "AnyClass",
                                                arg1: :any_value,
                                                arg2: -> { counter += 1 }
      custom_attrs = {
        arg1: :custom,
        arg3: :additional_value,
      }

      # rubocop:disable Metrics/LineLength
      an_instance = nil
      expect {
        an_instance = Radius::Spec::ModelFactory.create("AnyClass", custom_attrs) { |obj|
          block_initialized = obj
        }
      }.to change {
        block_initialized
      }.from(false)
      # rubocop:enable Metrics/LineLength
      expect(block_initialized).to be an_instance
      expect(an_instance).to be_an_instance_of(AnyClass).and have_attributes(
        arg1: :custom,
        arg2: 1,
        arg3: :additional_value,
      )
    end

    it "persists objects which respond to `save!`" do
      stub_const(
        "AnyClass",
        Struct.new(:save_called, keyword_init: true) {
          def save!
            self.save_called = true
          end
        },
      )
      Radius::Spec::ModelFactory.define_factory "AnyClass"

      an_instance = Radius::Spec::ModelFactory.create(
        "AnyClass",
        save_called: false,
      )
      expect(an_instance.save_called).to be true
    end

    it "yields to the provided block before calling `save!`" do
      call_order = []
      stub_const(
        "AnyClass",
        Struct.new(:arg, keyword_init: true) { |klass|
          klass.define_method(:initialize) do |*|
            call_order << :initialize
          end

          klass.define_method(:save!) do
            call_order << :save!
          end
        },
      )
      Radius::Spec::ModelFactory.define_factory "AnyClass"

      expect {
        Radius::Spec::ModelFactory.create("AnyClass")
      }.to change {
        call_order
      }.from([]).to(%i[initialize save!])
    end
  end

  context "using the model factory in specs" do
    it "helpers are not included by default", :aggregate_failures do
      expect {
        build(Object)
      }.to raise_error NoMethodError

      expect {
        create(Object)
      }.to raise_error NoMethodError
    end

    shared_examples "factory inclusion" do
      before do
        stub_const "AnyClass", Struct.new(:attr1, :attr2, keyword_init: true)
        Radius::Spec::ModelFactory.define_factory(
          "AnyClass",
          attr1: "Any Attr1 Value",
          attr2: "Any Attr2 Value",
        )
      end

      it "includes the `build` helper" do
        an_instance = build("AnyClass", attr1: "Custom Value")
        expect(an_instance).to be_an_instance_of(AnyClass).and have_attributes(
          attr1: "Custom Value",
          attr2: "Any Attr2 Value",
        )
      end

      it "includes the `create` helper" do
        an_instance = create("AnyClass", attr2: "Custom Value")
        expect(an_instance).to be_an_instance_of(AnyClass).and have_attributes(
          attr1: "Any Attr1 Value",
          attr2: "Custom Value",
        )
      end
    end

    describe "using the model factory", "via module inclusion" do
      include Radius::Spec::ModelFactory
      include_examples "factory inclusion"
    end

    describe "using the model factory", "via metadata", :model_factory do
      include_examples "factory inclusion"
    end
  end
end
