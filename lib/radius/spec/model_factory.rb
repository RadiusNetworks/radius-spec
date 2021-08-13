# frozen_string_literal: true

module Radius
  module Spec
    # Basic Model Factory
    #
    # This factory is **not** Rails specific. It works for any object type that
    # responds to `new` with a hash of attributes or keywords; including
    # `Struct` using the new Ruby 2.5 `keyword_init` flag.
    #
    # To make this feature available require it after the gem:
    #
    # ```ruby
    # require 'radius/spec'
    # require 'radius/spec/model_factory'
    # ```
    #
    # ### Storing Factory Templates
    #
    # Our convention is to store all of a project's factory templates in the
    # file `spec/support/model_factories.rb`. As this is our convention, when
    # the model factory is required it will attempt to load this file
    # automatically as a convenience.
    #
    # ### Including Helpers in Specs
    #
    # There are multiple ways you can build object instances using this model
    # factory. Which method you choose depends on how much perceived
    # magic/syntactic sugar you want:
    #
    #   - call the model factory directly
    #   - manually include the factory helper methods in the specs
    #   - use metadata to auto load this feature and include it in the specs
    #
    # When using the metadata option you do not need to explicitly require the
    # model factory feature. This gem registers metadata with the RSpec
    # configuration when it loads and `RSpec` is defined. When the metadata is
    # first used it will automatically require the model factory feature and
    # include the helpers.
    #
    # Any of following metadata will include the factory helpers:
    #
    #   - `:model_factory`
    #   - `:model_factories`
    #   - `type: :controller`
    #   - `type: :feature`
    #   - `type: :job`
    #   - `type: :model`
    #   - `type: :request`
    #   - `type: :system`
    #
    # @example defining a single factory template
    #   require 'radius/spec/model_factory'
    #
    #   Radius::Spec::ModelFactory.define_factory(
    #     "AnyClass",
    #     attr1: :any_value,
    #     attr2: :another_value,
    #   )
    # @example defining multiple templates
    #   require 'radius/spec/model_factory'
    #
    #   Radius::Spec::ModelFactory.catalog do |c|
    #     c.factory "AnyClass", attr1: :any_value, attr2: :another_value
    #
    #     c.factory "AnotherClass",
    #               attr1: :any_value,
    #               attr2: :another_value,
    #               attr3: %i[any list of values]
    #   end
    # @example building a domain model from a factory template
    #   an_instance = Radius::Spec::ModelFactory.build("AnyClass")
    # @example building a domain model with custom attributes
    #   an_instance = Radius::Spec::ModelFactory.build(
    #     "AnyClass",
    #     attr1: "Any Custom Value",
    #     attr2: %w[any custom array],
    #   )
    # @example call the model factory directly in specs
    #   require 'radius/spec/model_factory'
    #
    #   RSpec.describe AnyClass do
    #     it "includes the factory helpers" do
    #       an_object = Radius::Spec::ModelFactory.build("AnyClass")
    #       expect(an_object.name).to eq "Any Name"
    #     end
    #   end
    # @example manually include the factory helper methods
    #   require 'radius/spec/model_factory'
    #
    #   RSpec.describe AnyClass do
    #     include Radius::Spec::ModelFactory
    #
    #     it "includes the factory helpers" do
    #       an_object = build(AnyClass)
    #       expect(an_object.name).to eq "Any Name"
    #     end
    #   end
    # @example use metadata to auto include the factory helper methods
    #   RSpec.describe AnyClass, :model_factory do
    #     it "includes the factory helpers" do
    #       an_object = build("AnyClass")
    #       expect(an_object.name).to eq "Any Name"
    #     end
    #   end
    # @since 0.1.0
    module ModelFactory
      # Indicates that a model does not have a template registered with the
      # factory {Radius::Spec::ModelFactory.catalog}.
      class TemplateNotFound < KeyError; end

      class << self
        # Suggested method for defining multiple factory templates at once.
        #
        # Most projects end up having many domain models which need factories
        # defined. Having to reference the full module constant every time you
        # want to define a factory is tedious. Use this to define all of your
        # model templates within a block.
        #
        # @example
        #   require 'radius/spec/model_factory'
        #
        #   Radius::Spec::ModelFactory.catalog do |c|
        #     c.factory "AnyClass", attr1: :any_value, attr2: :another_value
        #
        #     c.factory "AnotherClass",
        #               attr1: :any_value,
        #               attr2: :another_value,
        #               attr3: %i[any list of values]
        #   end
        # @yieldparam catalog current catalog storing the registered templates
        # @return [void]
        # @see .factory
        def catalog
          yield self
        end

        # Convenience helper for registering a template to the current catalog.
        #
        # Registers the `class_name` in the catalog mapped to the provided
        # `attrs` attribute template.
        #
        # ### Lazy Class Loading
        #
        # When testing in isolation we often don't want to wait a long time for
        # a lot of unnecessary project/app code to load. With that in mind we
        # want to keep loading the model factory and all factory templates as
        # fast as possible. This mean not loading the associated project/app
        # code at factory template definition time. This way if you only need
        # one or two factories your remaining domain model code won't be
        # loaded.
        #
        # Lazy class loading occurs when you register factory template using a
        # string or symbol for the fully qualified `class_name`. The only
        # requirement for this feature is that the class must be loaded by the
        # project/app, or made available via some auto-loading mechanism, by
        # the time the first instance is built by the factory.
        #
        # ### Template Attribute Keys
        #
        # Attribute keys may be defined using either strings or symbols.
        # However, they will be stored internally as symbols. This means that
        # when an object instance is create using the factory the **attribute
        # hash will be provided to `new` with _symbol_ keys**.
        #
        # ### Dynamic Attribute Values (i.e. Generators)
        #
        # Dynamic attributes values may be registered by providing a `Proc` for
        # the value. For any template attribute which has a `Proc` for a value
        # making an instance through the factory will send `call` to the proc
        # with no args.
        #
        # <div class="note notetag">
        # <strong>Note:</strong>
        # <div class="inline">
        # <p>
        # This only applies to template values which are instances of
        # <code>Proc</code>. If you define a template value using another
        # object which responds to <code>call</code> that object will be set as
        # the built instance's attribute value without receiving
        # <code>call</code>.
        # </p>
        # </div>
        # </div>
        #
        # While this is a powerful technique we suggest keeping it's use to a
        # minimum. There's a lot of benefit to generative, mutation, and fuzzy
        # testing. We just aren't convinced it should be the default when you
        # generate unit / general integration test data.
        #
        # ### Optional and Required attributes
        #
        # Templates may use the special symbols `:optional` and `:required` as
        # a means of documenting attributes. These special symbols are meant as
        # descriptive placeholders for developers reading the factory
        # definition. Any template attribute with a value of `:optional`, which
        # is not overwritten by a custom value, will be removed just prior to
        # building a new instance.
        #
        # Those attributes marked as `:required` will not be removed. Instead
        # the symbol `:required` will be set as the attribute's value if it
        # isn't overwritten by the custom data. This type of value is a _benign
        # default_ meant to cause errors to provide a more helpful description
        # (i.e. this attribute is required).
        #
        # For Rails projects, we suggest using `:required` for any association
        # that is necessary for the object to be valid. We do not recommend
        # attempting to generate default records within the factory as this can
        # lead to unexpected database state; and hide relevant information away
        # from the specs which may depend on it.
        #
        # ### "Safe" Attribute Duplication
        #
        # In an effort to help limit accidental state leak between instances
        # the factory will duplicate all non-frozen template values prior to
        # building the instance. Duplication is only applied to the values
        # registered for the templates. Custom values provided when building
        # the instance are not duplicated.
        #
        # @example register a domain template using class constant
        #   Radius::Spec::ModelFactory.define_factory AnyClass,
        #                                             any_attr: :any_value
        # @example register a domain template using lazy class loading
        #   Radius::Spec::ModelFactory.define_factory :AnyClass,
        #                                             any_attr: :any_value
        # @example register a nested class using lazy class loading
        #   Radius::Spec::ModelFactory.define_factory "AnyModule::AnyClass",
        #                                             any_attr: :any_value
        # @example advanced example using additional features
        #   Radius::Spec::ModelFactory.define_factory(
        #     "AnyClass",
        #     dynamic: -> { rand(0..100) },
        #     safe_array: [1, 2, 3],
        #   )
        #
        #   AnyClass = Struct.new(:dynamic, :safe_array, keyword_init: true)
        #
        #   instance_a = Radius::Spec::ModelFactory.build("AnyClass")
        #   # => #<struct AnyClass dynamic=10, safe_array=[1, 2, 3]>
        #
        #   instance_a.safe_array << 4
        #   # => #<struct AnyClass dynamic=10, safe_array=[1, 2, 3, 4]>
        #
        #   instance_b = Radius::Spec::ModelFactory.build("AnyClass")
        #   # => #<struct AnyClass dynamic=32, safe_array=[1, 2, 3]>
        # @param class_name [Class, String, Symbol] fully qualified domain
        #   model class name or constant
        # @param attrs [Hash{String,Symbol => Object}] hash of attributes and
        #   default values to register
        # @return [void]
        def define_factory(class_name, attrs = {})
          templates[class_name.to_s] = attrs.transform_keys(&:to_sym).freeze
        end
        alias_method :factory, :define_factory

        # @private
        def merge_attrs(template, custom_attrs)
          template_only = template.keys - custom_attrs.keys
          template.slice(*template_only)
                  .delete_if { |_, v| :optional == v }
                  .transform_values! { |v|
                    ::Radius::Spec::ModelFactory.safe_transform(v)
                  }
                  .merge(custom_attrs)
        end

        # @private
        def safe_transform(value)
          return value.call if value.is_a?(Proc)
          return value if value.frozen?

          value.dup
        end

        # @private
        def template(name)
          templates.fetch(name) {
            raise TemplateNotFound, "template not found: #{name}"
          }
        end

        # @private
        def templates
          @templates ||= {}
        end
      end

    module_function

      # Convenience wrapper for building a model template.
      #
      # All `custom_attrs` values are provided as is to the class initializer
      # (i.e. they are **not** duplicate or modified in any way). When an
      # attribute exists in both the registered template and `custom_attrs` the
      # value in `custom_attrs` will be used. The `custom_attrs` may also
      # include new attributes not defined in the factory template.
      #
      # ### Optional Block
      #
      # The `block` is optional. When provided it is passed directly to `new`
      # when initializing the instance. This is to support the common Ruby
      # idiom of yielding `self` within initialize:
      #
      # ```ruby
      # class AnyClass
      #   def initialize(attrs = {})
      #     # setup attrs
      #     yield self if block_given?
      #   end
      # end
      # ```
      #
      # <div class="note notetag">
      # <strong>Note:</strong>
      # <div class="inline">
      # <p>
      # Since Ruby always supports passing a block to a method, even if the
      # method does not use the block, it's possible the block will not run if
      # the class being instantiated does yield to it.
      # </p>
      # <p>
      # Also, while the common idiom is to <code>yield self</code> classes are
      # free to yield anything. You need to be aware of how the class normally
      # behaves when passing a block to <code>new</code>.
      # </p>
      # </div>
      # </div>
      #
      # The examples below show different ways of interacting with the
      # following domain model and registered factory template:
      #
      # ```ruby
      # Radius::Spec::ModelFactory.factory "AnyClass",
      #                                    simple_attr: "any value",
      #                                    array_attr:  %w[any value],
      #                                    optional_attr: :optional,
      #                                    dynamic_attr: -> { rand(0..100) }
      #
      # class AnyClass
      #   def initialize(**opts)
      #     opts.each do |k, v|
      #       public_send "#{k}=", v
      #     end
      #     yield self if block_given?
      #   end
      #
      #   attr_accessor :array_attr, :dynamic_attr, :optional_attr, :simple_attr
      # end
      # ```
      #
      # @example building the default template using lazy class loading
      #   Radius::Spec::ModelFactory.build("AnyClass")
      #   # => #<AnyClass @array_attr=["any", "value"],
      #   #               @dynamic_attr=88,
      #   #               @simple_attr="any value">
      # @example building the default template using class constant
      #   Radius::Spec::ModelFactory.build(AnyClass)
      #   # => #<AnyClass @array_attr=["any", "value"],
      #   #               @dynamic_attr=3,
      #   #               @simple_attr="any value">
      # @example building the default template with a block
      #   Radius::Spec::ModelFactory.build("AnyClass") { |instance|
      #     instance.simple_attr = "Block Value"
      #   }
      #   # => #<AnyClass @array_attr=["any", "value"],
      #   #               @dynamic_attr=27,
      #   #               @simple_attr="Block Value">
      # @example building an instance with custom attributes
      #   Radius::Spec::ModelFactory.build(
      #     "AnyClass",
      #     simple_attr: "Custom Value",
      #     dynamic_attr: "Static Value",
      #     optional_attr: "Optional Value",
      #   )
      #   # => #<AnyClass @array_attr=["any", "value"],
      #   #               @dynamic_attr="Static Value",
      #   #               @optional_attr="Optional Value",
      #   #               @simple_attr="Custom Value">
      # @example registered template values are safe from modification
      #   instance_a = Radius::Spec::ModelFactory.build("AnyClass")
      #   instance_b = Radius::Spec::ModelFactory.build("AnyClass")
      #   instance_a.simple_attr.upcase!
      #   instance_a.array_attr << "modified"
      #   puts "#{instance_a.simple_attr}: #{instance_a.array_attr}"
      #   puts "#{instance_b.simple_attr}: #{instance_b.array_attr}"
      #
      #   # Outputs:
      #   # ANY VALUE: ["any", "value", "modified"]
      #   # any value: ["any", "value"]
      # @example building instances with custom shared data
      #   shared_array = %w[this is shared]
      #   instance_a = Radius::Spec::ModelFactory.build(
      #     "AnyClass",
      #     array_attr: shared_array,
      #     simple_attr: "Instance A",
      #   )
      #   instance_b = Radius::Spec::ModelFactory.build(
      #     "AnyClass",
      #     array_attr: shared_array,
      #     simple_attr: "Instance B",
      #   )
      #   instance_a.array_attr << "modified"
      #   puts "#{instance_a.simple_attr}: #{instance_a.array_attr}"
      #   puts "#{instance_b.simple_attr}: #{instance_b.array_attr}"
      #
      #   # Outputs:
      #   # Instance A: ["this", "is", "shared", "modified"]
      #   # Instance B: ["this", "is", "shared", "modified"]
      # @param name [Class, String, Symbol] fully qualified domain model class
      #   name or constant
      # @param custom_attrs [Hash{String,Symbol => Object}] hash of custom
      #   attributes to replace registered template default values
      # @param block optional block which is passed through to `new` when
      #   instantiating `name`
      # @return instance of `name` instantiated with `custom_attrs` and the
      #   registered template attributes
      # @raise [TemplateNotFound] when no template is defined for `name`
      # @see .define_factory
      def build(name, custom_attrs = {}, &block)
        name = name.to_s
        template = ::Radius::Spec::ModelFactory.template(name)
        custom_attrs = custom_attrs.transform_keys(&:to_sym)
        attrs = ::Radius::Spec::ModelFactory.merge_attrs(template, custom_attrs)
        # TODO: Always yield to the provided block even if new doesn't
        ::Object.const_get(name).new(attrs, &block)
      end

      # Convenience wrapper for building, and persisting, a model template.
      #
      # This is a thin wrapper around:
      #
      # ```ruby
      # build(name, attrs, &block).tap(&:save!)
      # ```
      #
      # The persistence message `save!` will only be called on objects which
      # respond to it.
      #
      # @note It is generally suggested that you avoid using `build!` for new
      #   code. Instead be explicit about when and how objects are persisted.
      #   This allows you to have fine grain control over how your data is
      #   setup.
      #
      #   We suggest that you create instances which need to be persisted
      #   before your specs using the following syntax:
      #
      #   ```ruby
      #   let(:an_instance) { build("AnyClass") }
      #
      #   before do
      #     an_instance.save!
      #   end
      #   ```
      #
      # @param (see .build)
      # @return (see .build)
      # @raise (see .build)
      # @see .build
      # @see .define_factory
      # @since 0.5.0
      def build!(name, custom_attrs = {}, &block)
        instance = build(name, custom_attrs, &block)
        instance.save! if instance.respond_to?(:save!)
        instance
      end

      # Legacy helper provided for backwards compatibility support.
      #
      # This provides the same behavior as {.build!} and will be removed in a
      # future release.
      #
      # @param (see .build)
      # @return (see .build)
      # @raise (see .build)
      # @see .build
      # @see .define_factory
      def create(name, custom_attrs = {}, &block)
        build!(name, custom_attrs, &block)
      end
    end
  end
end

# Try to load the factories defined for the specs
#
# TODO: Remove this disabling of the Lint/SuppressedException cop once we upgrade to rubocop 0.81.0,
# where the `AllowComments` option is set to true by default.
#
# rubocop:disable Lint/SuppressedException
begin
  require 'support/model_factories'
rescue LoadError
  # Ignore as this is an optional convenience feature
end
# rubocop:enable Lint/SuppressedException
