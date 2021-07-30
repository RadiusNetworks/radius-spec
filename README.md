# Common RSpec Setup and Plug-ins

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
  # Project's with noisy dependencies, and Rails app, include this line to
  # disable warnings.
  config.warnings = false

  # Your project specific custom settings here
end
```

**NOTE:** By default warnings are enabled by this gem. Enabling Ruby warnings
is generally recommended. However, for large projects, and including most Rails
apps, with lots of noisy dependencies this can be an issue. For these projects,
we suggest disabling warnings per the above method.

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

Projects can inherit from the [base Rubocop config](.rubocop.yml). This can be
accomplished by using either the remote raw URL or dependency gem formats. With
either method we also strongly suggest setting the `inherit_mode` to `merge`
for both `Exclude` and `IgnoredPatterns`. This way you can append additional
exceptions without overwriting the defaults.

#### Inherit from Gem (Recommended Method)

```yaml
inherit_mode:
  merge:
    - Exclude
    - IgnoredPatterns

inherit_gem:
  radius-spec:
    - common_rubocop.yml
    # Use the following instead if it is a Rails project
    - common_rubocop_rails.yml
```

#### Inherit from URL

```yaml
inherit_mode:
  merge:
    - Exclude
    - IgnoredPatterns

# Available for projects which cannot include this gem (i.e. Ruby < 2.5)
inherit_from:
  - https://raw.githubusercontent.com/RadiusNetworks/radius-spec/main/common_rubocop.yml
  # Use the following instead if it is a Rails project
  - https://raw.githubusercontent.com/RadiusNetworks/radius-spec/main/common_rubocop_rails.yml
```

When using the raw URL you may need to add the following to the project's
`.gitignore` file:

```
.rubocop-https---raw-githubusercontent-com-RadiusNetworks-radius-spec-main-common-rubocop-rails-yml
.rubocop-https---raw-githubusercontent-com-RadiusNetworks-radius-spec-main-common-rubocop-yml
```

#### General Inheritance Notes

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
    - IgnoredPatterns

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

### Basic Model Factory

This factory is **not** Rails specific. It works for any object type that
responds to `new` with a hash of attributes or keywords; including `Struct`
using the new Ruby 2.5 `keyword_init` flag.

#### Defining Factory Templates

You can use the model factory directly to define a factory template:

```ruby
require 'radius/spec/model_factory'

Radius::Spec::ModelFactory.define_factory(
  "AnyClass",
  attr1: :any_value,
  attr2: :another_value,
)
```

Most projects end up needing to specify multiple factories. Having to reference
the full module every time you want to define a factory is tedious. When you
need to define multiple factories we recommended using the factory catalog:

```ruby
require 'radius/spec/model_factory'

Radius::Spec::ModelFactory.catalog do |c|
  c.factory "AnyClass", attr1: :any_value, attr2: :another_value

  c.factory "AnotherClass",
            attr1: :any_value,
            attr2: :another_value,
            attr3: %i[any list of values]
end
```

##### Storing Factory Templates

Our convention is to store all of a project's factory templates in the file
`spec/support/model_factories.rb`. As this is our convention, when the model
factory is required it will attempt to load this file automatically as a
convenience.

##### Lazy Class Loading

When testing in isolation we often don't want to wait a long time for a lot of
unnecessary project/app code to load. With that in mind we want to keep loading
the model factory and all factory templates as fast as possible. This mean not
loading the associated project/app code at factory template definition time.
This way if you only need one or two factories your remaining domain model code
won't be loaded.

To utilize this lazy loading define your template using either a string or
symbol class name:

```ruby
Radius::Spec::ModelFactory.catalog do |c|
  c.factory :AnyClass, attr1: :any_value, attr2: :another_value

  c.factory "AnotherClass",
            attr1: :any_value,
            attr2: :another_value,
            attr3: %i[any list of values]

  c.factory "Nested::Module::SomeClass", attr1: :any_value
end
```

The only requirement for this feature is that the class must be loaded by the
project/app, or it uses an auto-loading mechanism, by the time the first
instance is built by the factory.

Also, this still supports defining the factory template using the class
constant so no changes need to be made if that's your preference.

##### Template Attribute Keys

Attribute keys may be defined using either strings or symbols. However, they
will be stored internally as symbols. This means that when an object instance
is created using the factory the attribute hash will be provided to `new` with
symbol keys.

##### Dynamic Attribute Values (i.e. Generators)

We try to keep the special cases / rules to a minimum. To support dynamic
attributes we need to special case templates which define a `Proc` for an
attribute value. For any template attribute which has a `Proc` for a value
making an instance through the factory will send `call` to the proc with no
args.

> _NOTE: This only applies to instances of `Proc`. If you define a template
> value with another object which responds to `call` that object will be set as
> the attribute value without receiving `call`._

You can use this to define generators in a number of ways:

```ruby
Radius::Spec::ModelFactory.catalog do |c|
  # This is not thread safe.
  gid_counter = 0
  usually_gid_generator = -> { gid_counter += 1 }

  c.factory :AnyClass,
            gid: usually_gid_counter,
            temp: -> { rand(0..100) }

  c.factory "AnotherClass",
            gid: usually_gid_counter,
            uuid: -> { SecureRandom.uuid }
end
```

> _NOTE: As of Ruby 2.5 `-> {}`, `lambda {}`, `proc {}`, and `Proc.new` are all
> instances of `Proc`._

While this is a powerful technique we suggest keeping it's use to a minimum.
There's a lot of benefit to generative, mutation, and fuzzy testing. We just
aren't convinced it should be the default when you generate unit / general
integration test data.

##### Self Documenting Attributes

Factory templates may use the special symbols `:optional` and `:required` as a
means of self documenting attributes. These are meant as descriptive
placeholders for developers reading the factory definition. Any template
attribute with a value of `:optional`, which is not overwritten by a custom
value, will be removed just prior to building a new instance.

Those attributes marked as `:required` will not be removed. Instead the symbol
`:required` will be set as the attribute's value if it isn't overwritten by the
custom data. This way, if it's considered an invalid, it will helpfully produce
a more descriptive error message. And if it's considered a valid value, will
provide some contextual information when used else where.

For Rails projects, we suggest using `:required` for any association that is
necessary for the object to be valid. We do not recommend attempting to
generate default records within the factory as this can lead to unexpected
database state; and hide relevant information away from the specs which may
depend on it.

##### "Safe" Attribute Duplication

In an effort to help limit accidental state leak between instances the factory
will duplicate all non-frozen template values prior to building the instance.
Duplication is only applied to the values registered for the templates. Custom
values provided when building the instance are not duplicated.

#### Usage

There are multiple ways you can build object instances using the model factory.
Which method you choose depends on how much perceived magic/syntactic sugar you
want:

  - Call the model factory directly to instantiate instances:

    ```ruby
    require 'radius/spec/model_factory'

    Radius::Spec::ModelFactory.define_factory "AnyClass", name: "Any Name"

    AnyClass = Struct.new(:name, keyword_init: true)

    default_instance = Radius::Spec::ModelFactory.build("AnyClass")
    # => #<struct AnyClass name="Any Name">

    default_instance.name
    # => "Any Name"

    custom_instance = Radius::Spec::ModelFactory.build(
      :AnyClass,
      name: "Any Custom Name",
    )
    # => #<struct AnyClass name="Any Custom Name">

    custom_instance.name
    # => "Any Custom Name"
    ```

  - Include the factory helper methods explicitly:

    ```ruby
    require 'radius/spec/model_factory'

    RSpec.describe AnyClass do
      include Radius::Spec::ModelFactory

      it "includes the factory helpers" do
        an_object = build(AnyClass)
        expect(an_object.name).to eq "Any Name"
      end
    end
    ```

  - Include the factory helpers via metadata:

    ```ruby
    RSpec.describe AnyClass, :model_factory do
      it "includes the factory helpers" do
        an_object = build("AnyClass")
        expect(an_object.name).to eq "Any Name"
      end
    end
    ```

    When using this metadata option you do not need to explicitly require the
    model factory feature. This gem registers metadata with the RSpec
    configuration when it loads and `RSpec` is defined. When the metadata is
    first used it will automatically require the model factory feature and
    include the helpers.

    Any of following metadata will include the factory helpers:

      - `:model_factory`
      - `:model_factories`
      - `type: :controller`
      - `type: :feature`
      - `type: :job`
      - `type: :model`
      - `type: :request`
      - `type: :system`

There are a few behaviors to note for using the builder:

  - the class constant or fully qualified class name as a string (or symbol)
    may be provided to the builder

    This mirrors how defining the factory behaves.

  - custom attribute values provided to the builder will replace any of the
    registered defaults in the template

  - new attributes not defined in the template may be included in the custom
    attributes

    These new attributes will be included with the other attributes and passed
    to `new`.

  - unlike the registered template attributes, all custom attributes (even
    those that replace the registered attributes) are not modified or
    duplicated in any way

    This means if you provide an array or hash as an attribute value those
    exact instances will be sent to `new`. Additionally, if you provide a
    `Proc` as an attribute value it will be sent to new directly without
    receiving `call`.

##### Optional Block

Both `build` and `build!` support providing an optional block. This block is
passed directly to `new` when creating the object. This is to support the
common Ruby idiom of yielding `self` within initialize:

```ruby
class AnyClass
  def initialize(attrs = {})
    # setup attrs
    yield self if block_given?
  end
end

RSpec.describe AnyClass, :model_factory do
  it "passes the block to the object initializer" do
    block_capture = nil
    an_object = build("AnyClass") { |instance| block_capture = instance }
    expect(block_capture).to be an_object
  end
end
```

Since Ruby always supports passing a block to a method, even if the method does
not use the block, it's possible the block will not run if the class being
instantiated does not do anything with it.

Also, while the common idiom is to `yield self` classes are free to yield
anything. You need to be aware of how the class normally behaves when using
this feature.

##### "Creating" Instances

We suggest that you create instances using the following syntax:

```ruby
let(:an_instance) { build("AnyClass") }

before do
  an_instance.save!
end
```

Or alternatively:

```ruby
created_instance = build("AnyClass")
created_instance.save!
```

This way it is explicit what objects need to be persisted and in what order.

This can get tedious at times, especially for those who only need to create an
object to embed as an attribute of another object:

```ruby
collaborator = build("AnotherClass")
collaborator.save!

# collaborator is not used against directly after this line
created_instance = build("AnyClass", collaborator: collaborator)
created_instance.save!
```

For these cases the `build!` helper is available. This is simply an alias for
`build.tap(&:save!)`, but it supports omitting the `save!` call for objects
which do not support it. While it provides a safety guarantee that `save!` will
be called (instead of potentially `save`) it is less explicit.

```ruby
created_instance = build("AnyClass", collaborator: build!("AnotherClass"))
created_instance.save!
```

We still discourage the use of `build!` directly in `let` blocks for all of the
above mentioned reasons.

##### Legacy "Creating" Instances

Many of our existing projects use a legacy `create` helper. This is simply an
alias for `build!`. It is provided only for backwards compatibility support and
will be removed in a future release. New code should not use this method.

```ruby
created_instance = create("AnyClass")
```

### Negated Matchers

This gem defines the following [negated matchers](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/define-negated-matcher)
to allow for use [composing matchers](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/composing-matchers)
and with [compound expectations](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/compound-expectations).

| Matcher               | Inverse Of |
|-----------------------|------------|
| `exclude`             | [`include`](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/built-in-matchers/include-matcher) |
| `excluding`           | [`including`](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/built-in-matchers/include-matcher) |
| `not_eq`              | [`eq`](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/built-in-matchers/equality-matchers#compare-using-eq-(==)) |
| `not_change`          | [`change`](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/built-in-matchers/change-matcher) |
| `not_raise_error`     | [`raise_error`](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/built-in-matchers/raise-error-matcher) |
| `not_raise_exception` | [`raise_exception`](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/built-in-matchers/raise-error-matcher) |

#### Composing Matchers

There is no equivalent of `not_to` for composed matchers when only a subset of
the values needs to be negated. The negated matchers allow this type of fine
grain comparison:

```ruby
x = [1, 2, :value]
expect(x).to contain_exactly(be_odd, be_even, not_eq(:target))
```

This also works for verifying / stubbing a message with argument constraints:

```ruby
allow(obj).to receive(:meth).with(1, 2, not_eq(5))
obj.meth(1, 2, 3)
expect(obj).to have_received(:meth).with(not_eq(2), 2, 3)
```

This is great for verifying option hashes:

```ruby
expect(obj).to have_received(:meth).with(
  some_value,
  excluding(:some_opt, :another_opt),
)
```

#### Compound Negated Matchers

Normally it's not possible to chain to a negative match:

```ruby
a = b = 0
expect {
  a = 1
}.not_to change {
  b
}.from(0).and change {
  a
}.to(1)
```

Fails with:

    NotImplementedError:
      `expect(...).not_to matcher.and matcher` is not supported, since it creates
      a bit of an ambiguity. Instead, define negated versions of whatever
      matchers you wish to negate with `RSpec::Matchers.define_negated_matcher`
      and use `expect(...).to matcher.and matcher`.

Per the error the negated matcher allows for the following:

```ruby
a = b = 0
expect {
  a = 1
}.to change {
  a
}.to(1).and not_change {
  b
}.from(0)
```

Similarly, complex expectations can be set on lists:

```ruby
a = %i[red blue green]
expect(a).to include(:red).and exclude(:yellow)
expect(a).to exclude(:yellow).and include(:red)
```

### Working with Temp Files

These helpers are meant to ease the creation of temporary files to either stub
the data out or provide a location for data to be saved then verified.

In the case of file stubs, using these helpers allows you to co-locate the file
data with the specs. This makes it easy for someone to read the spec and
understand the test case; instead of having to find a fixture file and look at
its data. This also makes it easy to change the data between specs, allowing
them to focus on just what they need.

#### Usage

There are multiple ways you can use these helpers. Which method you choose
depends on how much perceived magic/syntactic sugar you want:

  - Call the helpers directly on the module:

    ```ruby
    require 'radius/spec/tempfile'

    def write_hello_world(filepath)
      File.write filepath, "Hello World"
    end

    Radius::Spec::Tempfile.using_tempfile do |pathname|
      write_hello_world pathname
      File.read(pathname)
      # => "Hello World"
    end
    ```
  - Include the helper methods explicitly:

    ```ruby
    require 'radius/spec/tempfile'

    RSpec.describe AnyClass do
      include Radius::Spec::Tempfile

      it "includes the file helpers" do
        using_tempfile do |pathname|
          code_under_test pathname
          expect(pathname.read).to eq "Any written data"
        end
      end
    end
    ```
  - Include the helper methods via metadata:

    ```ruby
    RSpec.describe AnyClass do
      it "includes the file helpers", :tempfile do
        using_tempfile do |pathname|
          code_under_test pathname
          expect(pathname.read).to eq "Any written data"
        end
      end
    end
    ```

    When using this metadata option you do not need to explicitly require the
    tempfile feature. This gem registers metadata with the RSpec configuration
    when it loads and `RSpec` is defined. When the metadata is first used it
    will automatically require the tempfile feature and include the helpers.

    Any of following metadata will include the factory helpers:

      - `:tempfile`
      - `:tmpfile`

There are a few additional behaviors to note:

  - Data can be stubbed by the helper through the `data` keyword arg:

    ```ruby
    stub_data = "Any file stub data text."
    Radius::Spec::Tempfile.using_tempfile(data: stub_data) do |stubpath|
      File.read(stubpath)
      # => "Any file stub data text."
    end
    ```

    It can even be inlined using heredocs:

    ```ruby
    Radius::Spec::Tempfile.using_tempfile(data: <<~TEXT) do |stubpath|
      Any file stub data text.
    TEXT
      # Yard formats heredoc args oddly
      File.read(stubpath)
      # => "Any file stub data text.\n"
    end
    ```

    > NOTE: That when inlining like this heredocs add an extra new line. To
    > remove it use `.chomp` on the kwarg:
    >
    > ```ruby
    > using_tempfile(data: <<~TEXT.chomp) do |pathname|
    >   This has no newline.
    > TEXT
    >   # ...
    > end
    > ```

  - Additional arguments and options are forwarded directly to
    [Tempfile.create](https://ruby-doc.org/stdlib/libdoc/tempfile/rdoc/Tempfile.html#method-c-create)

    This allows you to set custom file extensions:

    ```ruby
    Radius::Spec::Tempfile.using_tempfile(%w[custom_name .myext]) do |pathname|
      pathname.extname
      # => ".myext"
    end
    ```

    Or change the file encoding:

    ```ruby
    Radius::Spec::Tempfile.using_tempfile(encoding: "ISO-8859-1", data: <<~DATA) do |pathname|
      Résumé
    DATA
      # Yard formats heredoc args oddly
      File.read(pathname)
      # => "R\xE9sum\xE9\n"
    end
    ```

### Common VCR Configuration

A project must include both [`vcr`](https://rubygems.org/gems/vcr) and
[`webmock`](https://rubygems.org/gems/webmock) to use this configuration.
Neither of those gems will be installed as dependencies of this gem. This is
intended to give projects more flexibility in choosing which additional features
they will use.

The main `radius/spec/rspec` setup will load the common VCR configuration
automatically when a spec is tagged with the `:vcr` metadata. This will
configure VCR to:

  - save specs to `/spec/cassettes`

  - use record mode `once` when a single spec or spec file is run

    This helps ease the development of new specs without requiring any
    configuration / setting changes.

  - uses record mode `none` otherwise, along setting VCR to fail when unused
    interactions remain in a cassette

    This is intended to better alert developers to unexpected side effects of
    changes as any addition or removal of a request will cause a failure.

  - all `Authorization` HTTP headers are filtered by default

    This is a common oversight when recording specs. Often token based
    authentication is picked up by the other filtered environment settings, but
    basic authentication is not. Additionally, certain types of digest
    authentication may cause specs to leak state. This filtering guards all of
    these cases from accidental credential leak.

  - the following common sensitive, or often environment variable, settings are
    filtered

    Those settings which often change between developer machines, and even the
    CI server, can cause for flaky specs. It may also be frustrating for
    developers to have to adjust their local systems to match others just to
    get a few specs to pass. This is intended to help mitigate those issues:

    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
    - `GOOGLE_CLIENT_ID`
    - `GOOGLE_CLIENT_SECRET`
    - `RADIUS_OAUTH_PROVIDER_APP_ID`
    - `RADIUS_OAUTH_PROVIDER_APP_SECRET`
    - `RADIUS_OAUTH_PROVIDER_URL`

  - a project's local `support/vcr.rb` file will be loaded after the common
    VCR configuration loads; if it's available

    This allows projects to overwrite common settings if they need to, as well,
    as add on addition settings or filtering of data.

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
conduct](https://github.com/RadiusNetworks/radius-spec/blob/main/CODE_OF_CONDUCT.md).
