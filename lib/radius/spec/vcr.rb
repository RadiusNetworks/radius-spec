# frozen_string_literal: true

require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true

  record_mode = case
                when ENV.fetch('CI', false)
                  # Never let CI record
                  :none
                when RSpec.configuration.files_to_run.one?
                  # When developing new features we often run new specs in
                  # isolation as we write the code. This is the time to allow
                  # creating the cassettes.
                  :once
                else # rubocop:disable Lint/DuplicateBranch
                  # Default to blocking new requests to catch issues
                  :none
                end
  config.default_cassette_options = {
    record: record_mode,

    # Required for working proxy
    update_content_length_header: true,

    # Raise errors when recorded cassettes no longer match interactions
    allow_unused_http_interactions: false,
  }

  # Filter out common sensitive or environment specific data
  %w[
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    GOOGLE_CLIENT_ID
    GOOGLE_CLIENT_SECRET
    RADIUS_OAUTH_PROVIDER_APP_ID
    RADIUS_OAUTH_PROVIDER_APP_SECRET
    RADIUS_OAUTH_PROVIDER_URL
  ].each do |secret|
    # WARNING: It may seem tempting, but don't try to extract ENV[secret] to a local variable
    # here. `filter_sensitive_data` calls its block instead of exec-ing it, so a local variable
    # set outside the blocks won't be accessible inside them.
    config.filter_sensitive_data("<#{secret}>") { ENV[secret] }

    config.filter_sensitive_data("<#{secret}_FORM>") {
      URI.encode_www_form_component(ENV[secret]) if ENV[secret]
    }

    config.filter_sensitive_data("<#{secret}_URI>") {
      ERB::Util.url_encode(ENV[secret]) if ENV[secret]
    }

    config.filter_sensitive_data('<AUTHORIZATION_HEADER>') { |interaction|
      interaction.request.headers['Authorization']&.first
    }
  end
end

RSpec.configure do |config|
  {
    vcr_record: :once,
    vcr_record_new: :new_episodes,
  }.each do |tag, record_mode|
    config.define_derived_metadata(tag) do |metadata|
      case metadata[:vcr]
      when nil, true
        metadata[:vcr] = { record: record_mode }
      when Hash
        metadata[:vcr][:record] = record_mode
      else
        raise "Unknown VCR metadata value: #{metadata[:vcr].inspect}"
      end
    end
  end

  config.define_derived_metadata(:focus) do |metadata|
    # VCR is flagged as falsey
    next if metadata.key?(:vcr) && !metadata[:vcr]

    case metadata[:vcr]
    when nil, true
      metadata[:vcr] = { record: :once }
    when Hash
      metadata[:vcr][:record] ||= :once
    else
      raise "Unknown VCR metadata value: #{metadata[:vcr].inspect}"
    end
  end
end

# Try to any custom VCR config for the app
begin
  require 'support/vcr'
rescue LoadError
  # Ignore as this is an optional convenience feature
end
