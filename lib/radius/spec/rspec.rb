# frozen_string_literal: true

# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
    mocks.allow_message_expectations_on_nil = false
    mocks.verify_doubled_constant_names = (
      ENV.key?("CI") || !config.files_to_run.one?
    )
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = ".rspec_status"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end

  # RSpec will exit with code 0 indicating success if no examples are defined.
  # This option allows you to configure RSpec to exit with code 1 indicating
  # failure. This is useful in CI environments, as it helps detect when you've
  # misconfigured RSpec to look for specs in the wrong place or with the wrong
  # pattern. See http://rspec.info/blog/2017/05/rspec-3-6-has-been-released/#core-configfailifnoexamples
  config.fail_if_no_examples = true

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10 if ENV["CI"]

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.when_first_matching_example_defined(
    :model_factory,
    :model_factories,
  ) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, :model_factory, :model_factories
  end

  config.when_first_matching_example_defined(:tempfile, :tmpfile) do
    require 'radius/spec/tempfile'
    config.include Radius::Spec::Tempfile, :tempfile, :tmpfile
  end

  config.when_first_matching_example_defined(type: :controller) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, type: :controller
  end

  config.when_first_matching_example_defined(type: :feature) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, type: :feature
  end

  config.when_first_matching_example_defined(type: :job) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, type: :job
  end

  config.when_first_matching_example_defined(type: :mailer) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, type: :mailer
  end

  config.when_first_matching_example_defined(type: :model) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, type: :model
  end

  config.when_first_matching_example_defined(type: :request) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, type: :request
  end

  config.when_first_matching_example_defined(type: :system) do
    require 'radius/spec/model_factory'
    config.include Radius::Spec::ModelFactory, type: :system
  end

  config.when_first_matching_example_defined(:webmock) do
    require 'webmock/rspec'
  end

  config.when_first_matching_example_defined(:vcr, :vcr_record, :vcr_record_new) do
    require 'radius/spec/vcr'
  end
end

require 'radius/spec/rspec/negated_matchers'
