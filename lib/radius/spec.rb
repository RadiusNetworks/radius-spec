# frozen_string_literal: true

require "radius/spec/version"

module Radius
  # Namespace for RSpec plug-ins and helpers
  module Spec
  end
end

require "radius/spec/rspec" if defined?(RSpec)
