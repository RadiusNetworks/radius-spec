# frozen_string_literal: true

require 'radius/spec/vcr'

RSpec.describe "Radius::Spec::VCR", :vcr do
  it "loads 'spec/support/vcr.rb' by default" do
    expect(TEMP_SPEC_VCR_LOAD_CHECK).to eq true
  end

  it "configures VCR to filter common secret and environment data" do
    ENV['AWS_ACCESS_KEY_ID'] = 'Any-AWS-Access-Key'
    ENV['RADIUS_OAUTH_PROVIDER_URL'] = 'https://any.example.url'
    ENV['GOOGLE_CLIENT_ID'] = 'Any-Google-Client-ID'

    uri = URI('https://any.example.url?aws_id=Any-AWS-Access-Key')
    response = Net::HTTP.get_response(uri)

    # Verify expected cassette was used
    expect(response.body).to eq '{"client_id":"Any-Google-Client-ID"}'

    expect(File.read(VCR.current_cassette.file)).not_to include(
      "Any-AWS-Access-Key",
      "Any-Google-Client-ID",
      "https://any.example.url",
    )
  end

  it "configures VCR to filter common data even when encoded" do
    ENV['GOOGLE_CLIENT_ID'] = 'Any Google Client ID'
    ENV['GOOGLE_CLIENT_SECRET'] = 'Any Google Secret'

    uri = URI('http://www.example.com/search')
    uri.query = URI.encode_www_form(gid: 'Any Google Client ID')
    response = Net::HTTP.post_form(uri, 'secret' => 'Any Google Secret')

    # Verify expected cassette was used
    expect(response.body).to eq 'Custom Response'

    expect(File.read(VCR.current_cassette.file)).not_to include(
      'Any+Google+Client+ID',       # Form encoded
      'Any%20Google%20Client%20ID', # URL encoded
      'Any+Google+Secret',          # Form encoded
      'Any%20Google%20Secret',      # URL encoded
    )
  end

  it "configures VCR to filter authorization headers" do
    uri = URI('http://example.com')
    basic_auth_response = Net::HTTP.start(uri.hostname, uri.port) { |http|
      req = Net::HTTP::Get.new(uri)
      req.basic_auth 'user', 'pass'
      http.request(req)
    }

    # Verify expected cassette was used
    expect(basic_auth_response.body).to eq 'Basic Response'
    expect(File.read(VCR.current_cassette.file)).not_to include('Basic dXNlcjpwYXNz')

    json_auth_response = Net::HTTP.start(uri.hostname, uri.port) { |http|
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = 'Bearer ANY-AUTH-TOKEN'
      req['Content-Type'] = 'application/json'
      http.request(req)
    }

    # Verify expected cassette was used
    expect(json_auth_response.body).to eq 'JSON Response'
    expect(File.read(VCR.current_cassette.file)).not_to include('Bearer ANY-AUTH-TOKEN')
  end

  it "configures VCR to raise on unused HTTP interactions" do
    expect {
      # Originally recorded: Net::HTTP.get(URI("http://www.example.com"))
      VCR.use_cassette("unused_interactions", exclusive: true) do
        # No-op
      end
    }.to raise_error VCR::Errors::Error
  end

  it "allows the record mode to be set via custom metadata", vcr: { record: :none } do
    expect {
      Net::HTTP.get(URI("http://www.example.com"))
    }.to raise_error VCR::Errors::Error
  end
end
