# frozen_string_literal: true

module Radius
  module Spec
    # FIXME
    module ModelFactory
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
        def templates
          @templates ||= {}
        end
      end
    end
  end
end
