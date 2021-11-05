# frozen_string_literal: true

TEMP_SPEC_LOAD_CHECK = true

Radius::Spec::ModelFactory.catalog do |catalog|
  catalog.factory "AnyClass", any_arg: :any_value
end
