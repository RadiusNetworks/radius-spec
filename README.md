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

TODO: Write usage instructions here

## Features

### Common Rubocop Config

Projects can inherit from the [base Rubocop config](.rubocop.yml) by using
either the remote raw URL or dependency gem formats:

```yaml
# Recommended Method
inherit_gem:
  radius-spec:
    - .rubocop.yml
    # Use the following instead if it is a Rails project
    - .rubocop_rails.yml
```

```yaml
# Available for projects which cannot include this gem (i.e. Ruby < 2.5)
inherit_from:
  - https://raw.githubusercontent.com/RadiusNetworks/radius-spec/master/.rubocop.yml
  # Use the following instead if it is a Rails project
  - https://raw.githubusercontent.com/RadiusNetworks/radius-spec/master/.rubocop_rails.yml
```

When using the raw URL you may need to add the following to the project's
`.gitignore` file:

```
.rubocop-https---raw-githubusercontent-com-RadiusNetworks-radius-spec-master--rubocop-rails-yml
.rubocop-https---raw-githubusercontent-com-RadiusNetworks-radius-spec-master--rubocop-yml
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
