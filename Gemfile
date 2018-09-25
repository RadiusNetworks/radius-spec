# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in radius-spec.gemspec
gemspec

group :benchmark, optional: true do
  gem 'benchmark-ips', require: false
  # TODO: See if this gem has an update in the future as it's gemspec is too
  # strict and it was blocking other gems from installing / updating
  gem 'kalibera', require: false, git: 'https://github.com/cupakromer/libkalibera.git'
end

group :debug do
  gem "pry-byebug", "~> 3.6", require: false
end

group :documentation do
  gem 'redcarpet', require: false
  gem 'yard', '~> 0.9', require: false
end

group :plugins do
  gem "vcr", "~> 4.0", require: false
  gem "webmock", "~> 3.3", require: false
end
