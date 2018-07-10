## Development

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/v0.3.0...master)

### Enhancements

- Upgrade to Rubocop 0.58.x (Aaron Kromer, #10)
- Adjust common Rubocop configuration (Aaron Kromer, #7)
  - Disable `Naming/BinaryOperatorParameterName`
  - Disable `Style/RedundantReturn`
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

- Fix `NameError: undefined local variable or method `config` for Rails RSpec
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
