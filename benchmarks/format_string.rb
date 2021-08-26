# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/format_string.rb
require_relative 'bm_setup'

display_benchmark_header

SINGLE_TOKEN_HASH = { greeting: 'Hello' }.freeze
MULTI_TOKEN_HASH = {
  greeting: 'Hello',
  name: 'Benchmark',
  message: 'Always a good idea to benchmark',
}.freeze

# rubocop:disable Style/FormatString
section "Format String" do |bench|
  bench.report("String#%") do
    '%10s' % 'hoge' # rubocop:disable Style/FormatStringToken
  end

  bench.report("format") do
    format '%10s', 'hoge' # rubocop:disable Style/FormatStringToken
  end

  bench.report("sprintf") do
    sprintf '%10s', 'hoge' # rubocop:disable Style/FormatStringToken
  end
end
# rubocop:enable Style/FormatString

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Format String

```
Warming up --------------------------------------
            String#%   148.922k i/100ms
              format   162.561k i/100ms
             sprintf   157.745k i/100ms
Calculating -------------------------------------
            String#%      2.363M (± 0.8%) i/s -     11.914M in   5.049141s
              format      2.668M (± 0.8%) i/s -     13.330M in   5.002105s
             sprintf      2.609M (± 0.8%) i/s -     13.093M in   5.025561s
                   with 95.0% confidence

Comparison:
              format:  2668054.9 i/s
             sprintf:  2609234.8 i/s - 1.02x  (± 0.01) slower
            String#%:  2363040.2 i/s - 1.13x  (± 0.01) slower
                   with 95.0% confidence
```
