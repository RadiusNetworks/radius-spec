source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in radius-spec.gemspec
gemspec

group :debug do
  gem "pry-byebug", "~> 3.6", require: false
  gem "travis", require: false
end

group :documentation do
  gem 'yard', '~> 0.9', require: false
end

group :plugins do
  gem "vcr", "~> 4.0", require: false
  gem "webmock", "~> 3.3", require: false
end
