## Development

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.9.0...main)

### Enhancements

- TODO

### Bug Fixes

- TODO

## 0.12.0 (August 3, 2022)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.12.0...0.12.0)

### Enhancements

- Added Dependabot
- Upgraded VCR to 6.0
- Upgrade Rubocop Rails to 2.16
- Upgrade Rubocop to 1.33

### Bug Fixes

None
## 0.11.0 (January 21, 2022)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.10.0...0.11.0)

### Enhancements

- Adjust common Rubocop configuration (Aaron Hill, Aaron Kromer, Ben Reynolds, James Nebeker, JC Avena, Sam Kim)
  - Enable `Lint/NoReturnInBeginEndBlocks` by default
  - Set `AllowHttpProtocol: false` for `Bundler/InsecureProtocolSource` cop
  - Set `AllowNil: false` for `Lint/SuppressedException` cop
  - Enable `Naming/BlockForwarding` cop for future Ruby 3.1 usage
  - Disallow Ruby 3 `Style/NumberedParameters`
  - Enable `Style/StringChars` by default
  - Set `AllowMethodsWithArguments: true` for `Style/SymbolProc` cop
  - Disallow combined `&&` and `||` in single `unless` clauses
  - Enable `Naming/InclusiveLanguage` by default
- Adjust common Rubocop-Rails configuration (Alex Stone, James Nebeker, Aaron Kromer, Ben Reynolds, Sam Kim)
  - Enable `Rails/EnvironmentVariableAccess` (`AllowReads` to `true`)
  - Changed `Rails/FindBy`:`IgnoreWhereFirst` to `false`
  - Enable `Rails/ReversibleMigrationMethodDefinition`
- Upgrade to Rubocop Rails 2.12.x (Alex Stone, James Nebeker, Aaron Kromer, Ben Reynolds, Sam Kim)
- Upgrade to Rubocop Rails 2.13.x (Alex Stone, James Nebeker, Aaron Kromer, Ben Reynolds, Sam Kim)
- Upgrade to Rubocop 1.25.x (Alex Stone, James Nebeker, Aaron Kromer, Ben Reynolds, Sam Kim, JC Avena, Eric Ouellette, Aaron Hill)
- Include model factory helpers in helper specs by default (Alex Stone, James Nebeker, Aaron Kromer, Ben Reynolds, JC Avena, Eric Ouellette)

### Bug Fixes

None

## 0.10.0 (October 18, 2021)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.9.0...v0.10.0)

### Enhancements

- Upgrade to Rubocop Rails 2.8.x (Aaron Hill, Aaron Kromer, Ben Reynolds, James Nebeker, JC Avena, Sam Kim, Alex
  Stone #30, #32)
- Adjust common Rubocop Rails configuration (Aaron Hill, Aaron Kromer, Ben Reynolds, James Nebeker, JC Avena,
  Sam Kim, Alex Stone #30, #32)
  - Enable `Rails/AttributeDefaultBlockValue` by default
  - Enable `Rails/ArelStar` by default
  - Enable `Rails/DefaultScope` by default
  - Enable `Rails/FindById` by default
  - Enable `Rails/PluckId` by default
  - Enable `Rails/WhereEquals` by default
  - Use the more aggressive `aggressive` check for `Rails/PluckInWhere`
  - Use the more aggressive `aggressive` check for `Rails/ShortI18n`
  - Switch to new `AllowedMethods` attribute name for `Rails/SkipsModelValidations`
  - Disable `Rails/SquishedSQLHeredocs` by default
- Adjust common Rubocop configuration (Aaron Hill, Aaron Kromer, JC Avena, Sam
  Kim #32, #34)
  - Enable `Style/ClassMethodsDefinitions` by default
  - Enable `Style/CombinableLoops` by default
  - Enable `Style/KeywordParametersOrder` by default
  - Enable `Style/RedundantSelfAssignment` by default
  - Enable `Style/SoleNestedConditional` by default
  - Enable `Lint/DuplicateRequire` by default
  - Enable `Lint/EmptyFile` by default
  - Enable `Lint/TrailingCommaInAttributeDeclaration` by default
  - Enable `Lint/UselessMethodDefinition` by default
  - Exclude the following testing methods from `Metrics/BlockLength`
    - 'describe'
    - 'shared_context'
    - 'shared_examples'
    - 'RSpec.describe'
    - 'RSpec.shared_context'
    - 'RSpec.shared_examples'

### Bug Fixes

None


## 0.9.0 (September 30, 2021)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.8.0...v0.9.0)

### Enhancements

- Upgrade to Rubocop 0.89.x (Aaron Hill, Aaron Kromer, Ben Reynolds, Chris
  Hoffman, James Nebeker, JC Avena, Sam Kim #27)
- Upgrade to Rubocop Rails 2.6.x (Aaron Hill, Aaron Kromer, Ben Reynolds, Chris
  Hoffman, James Nebeker, JC Avena, Sam Kim #27)
- Adjust common Rubocop configuration (Aaron Hill, Aaron Kromer, Ben Reynolds,
  Chris Hoffman, James Nebeker, JC Avena, Sam Kim #27)
  - Configure multiple metrics to use the `CountAsOne` option for array, hash
    and heredocs
  - Disable `Style/SlicingWithRange` as we do not care about the style
- Includes new `shared_example` / `shared_context` inclusion aliases
  `has_behavior` and `it_has_behavior` for behavior driven development language
  (Aaron Kromer, Ben Reynolds #28)

### Bug Fixes

None

### Breaking Change

- Change the default behavior from `:warn` to `:raise` for RSpec expectations
  behavior `on_potential_false_positives` (Aaron Kromer, Ben Reynolds #28)


## 0.8.0 (August 26, 2021)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.7.0...v0.8.0)

### Enhancements

- Upgrade to Rubocop 0.82.x (Aaron Hill, Aaron Kromer, Ben Reynolds, Chris
  Hoffman, James Nebeker, JC Avena #26)
- Upgrade to Rubocop Rails 2.5.x (Aaron Hill, Aaron Kromer, Ben Reynolds, Chris
  Hoffman, James Nebeker, JC Avena #26)
- Adjust common Rubocop configuration (Aaron Hill, Aaron Kromer, Ben Reynolds,
  Chris Hoffman, James Nebeker, JC Avena #26)
  - Rename metrics/configuration parameters per version upgrade requirements
  - Use the stricter `always_true` check for `Style/FrozenStringLiteralComment`
  - Opt-in to new cops/checks behaving per their default settings
- Adjust common Rubocop Rails configuration (Aaron Hill, Aaron Kromer, Ben
  Reynolds, Chris Hoffman, James Nebeker, JC Avena #26)
  - Disable `Rails/IndexBy` by default
  - Disable `Rails/IndexWith` by default

### Bug Fixes

None


## 0.7.0 (July 23, 2021)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.6.0...0.7.0)

### Enhancements

- Upgrade to Rubocop 0.73.x (Aaron Hill, Aaron Kromer, Ben Reynolds, Chris
  Hoffman, James Nebeker #24)
- Upgrade to Rubocop Rails 2.2.x (Aaron Hill, Aaron Kromer, Ben Reynolds, Chris
  Hoffman, James Nebeker #24)
- Adjust common Rubocop configuration (Aaron Hill, Aaron Kromer, Ben Reynolds,
  Chris Hoffman, James Nebeker #24)
  - Target Ruby 2.7 by default
  - Enable `Lint/HeredocMethodCallPosition` by default
  - Use `StandardError` for the suggested parent classes of errors
  - Bump metric check maximums to provide a little more wiggle room
  - Disable `Naming/RescuedExceptionsVariableName` by default
- Adjust common Rubocop Rails configuration (Aaron Hill, Aaron Kromer, Ben
  Reynolds, Chris Hoffman, James Nebeker #24)
  - Disable `Rails/IgnoredSkipActionFilterOption` by default

### Bug Fixes

None


## 0.6.0 (August 6, 2020)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.5.0...v0.6.0)

### Enhancements

- Exclude more bundler binstubs from Rubocop (Aaron Kromer, #18, #20)
- Exclude `chdir` and `Capybara.register_driver` configuration blocks from
  `Metrics/BlockLength` checks (Aaron Kromer, #18)
- Exclude gem specs from block and line length metrics (Aaron Kromer, #20)
- Standardize on key style of `Layout/AlignHash` (Aaron Kromer, #18)
- Upgrade to Rubocop 0.62.x (Aaron Kromer, #21)

### Bug Fixes

None


## 0.5.0 (September 26, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.4.0...v0.5.0)

### Enhancements

- Add common VCR configuration (Aaron Kromer, #16)
  - Filters out `Authorization` headers
  - Filters out the following sensitive/environment varying `ENV` values, as
    well as their URL and form encoded variants:
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
    - `GOOGLE_CLIENT_ID`
    - `GOOGLE_CLIENT_SECRET`
    - `RADIUS_OAUTH_PROVIDER_APP_ID`
    - `RADIUS_OAUTH_PROVIDER_APP_SECRET`
    - `RADIUS_OAUTH_PROVIDER_URL`
- Add "temp file" helpers for working with file stubs (Aaron Kromer, #15)
- Upgrade to Rubocop 0.59.x (Aaron Kromer, #14)
- Adjust common Rubocop configuration (Aaron Kromer, #14)
  - `Layout/EmptyLineAfterGuardClause` is enabled by default
  - Enable `Rails/SaveBang` to highlight potential lurking issues
  - Expand `Rails/FindBy` and `Rails/FindEach` to check all `/app` and `/lib`
  - Add more functional methods
    - `default_scope`
    - `filter_sensitive_data`
- Add `build!` factory method to compliment `build` to help resolving Rubocop
  violations for `Rails/SaveBang` (Aaron Kromer, #14)
- Load model factory for specs tagged with 'type: :mailer' (Aaron Kromer, #11)
- Include the following negated RSpec matchers (Aaron Kromer, #12)
  - `exclude` / `excluding`
  - `not_eq`
  - `not_change`
  - `not_raise_error` / `not_raise_exception`

### Bug Fixes

- Fix `NoMethodError: undefined method 'strip'` when the fixture path is a
  `Pathname` object (Aaron Kromer, #13)


## 0.4.0 (July 10, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.3.0...v0.4.0)

### Enhancements

- Upgrade to Rubocop 0.58.x (Aaron Kromer, #10)
- Add more custom extra details for customized cops (Aaron Kromer, #10)
- Adjust common Rubocop configuration
  - Disable `Naming/BinaryOperatorParameterName` (Aaron Kromer, #7)
  - Disable `Style/RedundantReturn` (Aaron Kromer, #7)
  - Allow optional leading underscores for memoized instance variable names to
    support modules wanting to reduce conflicts / collisions. (Aaron Kromer, #10)
- Adjust common Rubocop Rails configuration (Aaron Kromer, #7)
  - Exclude Rails controllers from Rubocop's `Metrics/MethodLength` due to
    `respond_to` / `format` and permitted params methods
  - Disable `Rails/HasAndBelongsToMany`
  - Exclude Rails app `config/routes.rb` from `Metrics/BlockLength`

### Bug Fixes

- Add more functional methods to Rubocop config (Aaron Kromer, #7)
  - `create`
  - `create!`
  - `build`
  - `build!`
- Support running system specs in isolation (Aaron Kromer, #9)


## 0.3.0 (June 15, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.2.1...v0.3.0)

### Breaking Change

- Lock Rubocop to a minor release version in gemspec (Aaron Kromer, #5)

### Enhancements

- Adjust common Rubocop configuration (Aaron Kromer, #5)
  - Customize `Style/AndOr` to flag only conditionals allowing `and` / `or` for
    control flow
  - Add `find` to functional method blocks
  - Disable `Style/DoubleNegation` as this is a common Ruby idiom
  - Disable `Style/StringLiteralsInInterpolation` to stay consistent with our
    no preferences for single versus double quotes

### Bug Fixes

- Remove `Include` from common Rubocop all cops configuration to fix issues
  with Rubocop 0.56.0+ not seeing all expected files. (Aaron Kromer, #5)


## 0.2.1 (May 17, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.2.0...v0.2.1)

### Bug Fixes

-  Fix warning about overriding parameter (Aaron Kromer, #4)


## 0.2.0 (May 17, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.1.1...v0.2.0)

### Enhancements

- Adjust common Rubocop configuration (Aaron Kromer, #2):
  - Ignore `Lint/AmbiguousBlockAssociation` for specs
  - Ignore long lines due to Rubocop directives
  - Ignore long lines due to comments
  - Prefer a line length of 80, but don't complain until 100
  - Disable ASCII only comments
  - Set the `MinSize` for `Style/SymbolArray` and `Style/WordArray` to three
  - Use squiggly `<<~` heredoc indentation
  - Allow common `EOF` as a heredoc delimiter
  - Indent multi-line operations
  - Allow unspecified rescue as a catch-all
- Adjust common Rubocop Rails configuration (Aaron Kromer, #2):
  - Ignore `Rails/ApplicationRecord` for benchmarks
  - Ignore more common gem binstubs


## 0.1.1 (March 16, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.1.0...v0.1.1)

### Bug Fixes

- Fix `NameError: undefined local variable or method config` for Rails RSpec
  configuration (Aaron Kromer, #1)
- Fix model factory build issue in which registered template attributes, which
  use symbol keys, are not replaced by custom attributes using string keys
  (Aaron Kromer, #1)
- Exclude `spec/support/model_factories.rb` from `Metrics/BlockLength` in
  common Rubocop config (Aaron Kromer, 714b9b3)


## 0.1.0 (March 14, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/0fb9d553f493c7ba454f13c9d4332d62a336f0a4...v0.1.0)

### Initial release:

- Common Rubocop configuration
- Common Rails Rubocop configuration
- Basic model factory implementation
  - Auto loads the model factory feature based on RSpec metadata
  - Supports lazy loading project/app code using strings/symbols instead of
    class constants for faster registration
  - Includes helpers for `build` and `create` in specs
