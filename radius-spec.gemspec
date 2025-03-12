# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "radius/spec/version"

Gem::Specification.new do |spec|
  spec.name          = "radius-spec"
  spec.version       = Radius::Spec::VERSION
  spec.authors       = ["Radius Networks", "Aaron Kromer"]
  spec.email         = ["support@radiusnetworks.com"]

  spec.metadata      = {
    "bug_tracker_uri" => "https://github.com/RadiusNetworks/radius-spec/issues",
    "changelog_uri" => "https://github.com/RadiusNetworks/radius-spec/blob/v#{Radius::Spec::VERSION}/CHANGELOG.md",
    "source_code_uri" => "https://github.com/RadiusNetworks/radius-spec/tree/v#{Radius::Spec::VERSION}",
    "rubygems_mfa_required" => "true",
  }
  spec.summary       = "Radius Networks RSpec setup and plug-ins"
  spec.description   = "Standard RSpec setup and a collection of plug-ins " \
                       "to help improve specs."
  spec.homepage      = "https://github.com/RadiusNetworks/radius-spec"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1" # rubocop:disable Gemspec/RequiredRubyVersion

  spec.add_dependency "rspec", "~> 3.7"
  spec.add_dependency "rubocop", ">= 1.25", "< 1.74"
  spec.add_dependency "rubocop-rails", ">= 2.13", "< 2.30"
end
