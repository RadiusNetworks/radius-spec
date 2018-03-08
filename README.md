# Common RSpec Setup and Plug-ins

[![Build Status](https://travis-ci.org/RadiusNetworks/radius-spec.svg?branch=master)](https://travis-ci.org/RadiusNetworks/radius-spec)
[![Maintainability](https://api.codeclimate.com/v1/badges/701295df43d53e25eafe/maintainability)](https://codeclimate.com/github/RadiusNetworks/radius-spec/maintainability)
[![Gem Version](https://badge.fury.io/rb/radius-spec.svg)](https://badge.fury.io/rb/radius-spec)

Basic RSpec setup and plug-ins for use with Radius Networks Ruby / Rails
projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'radius-spec'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install radius-spec
```

## Usage

If you do not already have a project `.rspec` file we suggest creating one with
at least the following:

```ruby
--require spec_helper
```

You _should_ check this `.rspec` file into version control. See the [RSpec
`Configuration` docs](https://rspec.info/documentation/3.7/rspec-core/RSpec/Core/Configuration.html)
and [Relish examples](https://relishapp.com/rspec/rspec-core/v/3-7/docs/configuration/read-command-line-configuration-options-from-files)
for more on loading configuration options.

To load the default suggested RSpec configuration, require this gem at the top
of your `spec/spec_helper.rb` file. After requiring the gem you can include any
custom RSpec configuration in a `RSpec.configure` block as usual:

```ruby
# /spec/spec_helper.rb
# frozen_string_literal: true

require 'radius/spec'

RSpec.configure do |config|
  # Your project specific custom settings here
end
```

For Rails apps, we suggest a similar approach to your Rails helper:

```ruby
# /spec/rails_helper.rb
# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'radius/spec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Your project specific custom settings here
end
```

## Features

### Common Rubocop Config

Projects can inherit from the [base Rubocop config](.rubocop.yml) by using
either the remote raw URL or dependency gem formats:

```yaml
# Recommended Method
inherit_gem:
  radius-spec:
    - common_rubocop.yml
    # Use the following instead if it is a Rails project
    - common_rubocop_rails.yml
```

```yaml
# Available for projects which cannot include this gem (i.e. Ruby < 2.5)
inherit_from:
  - https://raw.githubusercontent.com/RadiusNetworks/radius-spec/master/common_rubocop.yml
  # Use the following instead if it is a Rails project
  - https://raw.githubusercontent.com/RadiusNetworks/radius-spec/master/common_rubocop_rails.yml
```

When using the raw URL you may need to add the following to the project's
`.gitignore` file:

```
.rubocop-https---raw-githubusercontent-com-RadiusNetworks-radius-spec-master-common-rubocop-rails-yml
.rubocop-https---raw-githubusercontent-com-RadiusNetworks-radius-spec-master-common-rubocop-yml
```

Be sure to include the project's local `.rubocop_todo.yml` **after** inheriting
the base configuration so that they take precedence. Also, use the directive
`inherit_mode` to specify which array configurations to merge together instead
of overriding the inherited value. This can be set both globally and for
specific cops:

```yaml
inherit_gem:
  radius-spec:
    - .rubocop.yml
    # Use the following instead if it is a Rails project
    - .rubocop_rails.yml
inherit_from: .rubocop_todo.yml

inherit_mode:
  merge:
    - Exclude

Style/For:
  inherit_mode:
    override:
      - Exclude
  Exclude:
    - bar.rb
```

Consult the [Rubocop documentation](https://rubocop.readthedocs.io/en/latest/configuration/#inheriting-configuration-from-a-remote-url)
for the most up-to-date syntax for including the [.rubocop.yml](.rubocop.yml)
config.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/RadiusNetworks/radius-spec. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## Code of Conduct

Everyone interacting in the Radius::Spec project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/RadiusNetworks/radius-spec/blob/master/CODE_OF_CONDUCT.md).
