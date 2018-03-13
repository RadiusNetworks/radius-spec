# frozen_string_literal: true

Radius::Spec::ModelFactory.catalog do |catalog|
  TEMP_SPEC_LOAD_CHECK = true
  catalog.factory "AnyClass", any_arg: :any_value
end
