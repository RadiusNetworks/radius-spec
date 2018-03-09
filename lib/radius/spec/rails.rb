# frozen_string_literal: true

# Ensure the gem, and default RSpec config, are already loaded
require 'radius/spec'
require 'radius/spec/rspec'
require 'rspec/rails'

RSpec.configure do
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = ::Rails.root.join("spec", "fixtures")

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Skip system tests by default.
  #
  # This is what Rails does by default:
  #
  # > By default, running `bin/rails` test won't run your system tests. Make
  # > sure to run `bin/rails test:system` to actually run them.
  #
  # Running system tests often requires additional external dependencies. Not
  # every project is setup to install all of the system test dependencies by
  # default. To avoid issues across projects we default to excluding these
  # specs. Projects are free to overwrite this filter in their custom RSpec
  # configuration.
  #
  # This can be overridden on the command line:
  #
  #     bin/rspec -t type:system
  #
  # See:
  #   - http://guides.rubyonrails.org/v5.1.4/testing.html#implementing-a-system-test
  #   - https://relishapp.com/rspec/rspec-core/v/3-7/docs/filtering/exclusion-filters
  #   - http://rspec.info/documentation/3.7/rspec-core/RSpec/Core/Configuration.html#filter_run_excluding-instance_method
  config.filter_run_excluding type: "system"

  # Always clear the cache before specs to avoid state leak problems
  config.before do
    Rails.cache.clear
  end
end
