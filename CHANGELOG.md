## 0.1.0 (March 14, 2018)

### Initial release:

- Common Rubocop configuration
- Common Rails Rubocop configuration
- Basic model factory implementation
  - Auto loads the model factory feature based on RSpec metadata
  - Supports lazy loading project/app code using strings/symbols instead of
    class constants for faster registration
  - Includes helpers for `build` and `create` in specs
