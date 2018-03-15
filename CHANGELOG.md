## Development

### Enhancements

- TODO

### Bug Fixes

- TODO


## 0.1.0 (March 14, 2018)

[Full Changelog](https://github.com/RadiusNetworks/radius-spec/compare/0fb9d553f493c7ba454f13c9d4332d62a336f0a4..v0.1.0)

### Initial release:

- Common Rubocop configuration
- Common Rails Rubocop configuration
- Basic model factory implementation
  - Auto loads the model factory feature based on RSpec metadata
  - Supports lazy loading project/app code using strings/symbols instead of
    class constants for faster registration
  - Includes helpers for `build` and `create` in specs
