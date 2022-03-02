# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in radius-spec.gemspec
gemspec

group :benchmark, optional: true do
  gem 'activesupport', require: false
  gem 'benchmark-ips', require: false
  gem 'kalibera', require: false
end

group :debug do
  gem "pry-byebug", "~> 3.6", require: false
end

group :documentation do
  gem 'redcarpet', require: false
  gem 'yard', '~> 0.9', require: false
end

group :plugins do
  gem "vcr", "~> 6.0", require: false
  gem "webmock", "~> 3.3", require: false
end
