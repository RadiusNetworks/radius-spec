# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "radius/spec/version"

Gem::Specification.new do |spec|
  spec.name          = "radius-spec"
  spec.version       = Radius::Spec::VERSION
  spec.authors       = ["Radius Networks", "Aaron Kromer"]
  spec.email         = ["support@radiusnetworks.com"]

  spec.summary       = "Radius Networks RSpec setup and plug-ins"
  spec.description   = "Standard RSpec setup and a collection of plug-ins " \
                       "to help improve specs."
  spec.homepage      = "https://github.com/RadiusNetworks/radius-spec"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "rspec", "~> 3.7"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
end
