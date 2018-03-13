# frozen_string_literal: true

module Radius
  module Spec
    # FIXME
    module ModelFactory
      # FIXME
      class TemplateNotFound < KeyError; end

      class << self
        # FIXME
        def catalog
          yield self
        end

        # FIXME
        def define_factory(class_name, attrs = {})
          templates[class_name.to_s] = attrs.transform_keys(&:to_sym).freeze
        end
        alias_method :factory, :define_factory

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

      # FIXME
      def build(name, custom_attrs = {}, &block)
        name = name.to_s
        template = ::Radius::Spec::ModelFactory.template(name)
        template_only = template.keys - custom_attrs.keys
        attrs = template.slice(*template_only)
                        .delete_if { |_, v| :optional == v }
                        .transform_values! { |v|
                          ::Radius::Spec::ModelFactory.safe_transform(v)
                        }
                        .merge(custom_attrs)
        # TODO: Always yield to the provided block even if new doesn't
        ::Object.const_get(name).new(attrs, &block)
      end

      # FIXME
      def create(name, custom_attrs = {}, &block)
        instance = build(name, custom_attrs, &block)
        instance.save! if instance.respond_to?(:save!)
        instance
      end
    end
  end
end
