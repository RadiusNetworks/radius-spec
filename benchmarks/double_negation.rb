# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/double_negation.rb
require_relative 'bm_setup'
require 'active_support'
require 'active_support/core_ext/object/blank'

display_benchmark_header

# rubocop:disable Style/NonNilCheck
# As this is basically a micro-benchmark we use the block with `while` idiom
[nil, [], Object.new].each do |x|
  section x.inspect do |bench|
    bench.report("!!") do |times|
      i = 0
      while i < times
        !!x
        i += 1
      end
    end

    bench.report("!nil?") do |times|
      i = 0
      while i < times
        !x.nil?
        i += 1
      end
    end

    bench.report("nil !=") do |times|
      i = 0
      while i < times
        nil != x
        i += 1
      end
    end

    bench.report("present?") do |times|
      i = 0
      while i < times
        x.present?
        i += 1
      end
    end
  end
end

# When performing the initial testing we used `x == nil`. However, that was
# shockingly slow for the empty array case. Because of that we inverted the
# conditional in the above condition. However, as proof of this oddity and to
# allow us to track behavior in future versions we include this additional
# benchmark showing the issue.
section "Empty array `nil` comparison" do |bench|
  x = []

  bench.report("!= nil") do |times|
    i = 0
    while i < times
      nil != x
      i += 1
    end
  end

  bench.report("nil !=") do |times|
    i = 0
    while i < times
      x != nil
      i += 1
    end
  end
end
# rubocop:enable Style/NonNilCheck

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: true

### Test Cases

#### nil

```
Warming up --------------------------------------
                  !!   320.852k i/100ms
               !nil?   313.833k i/100ms
              nil !=   330.298k i/100ms
            present?   294.813k i/100ms
Calculating -------------------------------------
                  !!     41.841M (± 0.6%) i/s -    207.591M in   5.000435s
               !nil?     30.851M (± 0.7%) i/s -    153.464M in   5.005301s
              nil !=     38.424M (± 0.5%) i/s -    191.573M in   5.007580s
            present?     19.660M (± 0.7%) i/s -     97.878M in   4.999761s
                   with 95.0% confidence

Comparison:
                  !!: 41841263.8 i/s
              nil !=: 38424408.4 i/s - 1.09x  (± 0.01) slower
               !nil?: 30850983.5 i/s - 1.36x  (± 0.01) slower
            present?: 19660459.4 i/s - 2.13x  (± 0.02) slower
                   with 95.0% confidence
```

#### []

```
Warming up --------------------------------------
                  !!   317.562k i/100ms
               !nil?   311.181k i/100ms
              nil !=   319.266k i/100ms
            present?   293.159k i/100ms
Calculating -------------------------------------
                  !!     42.487M (± 0.6%) i/s -    211.179M in   5.005333s
               !nil?     31.078M (± 0.5%) i/s -    154.968M in   5.005557s
              nil !=     38.313M (± 0.6%) i/s -    190.283M in   5.000799s
            present?     21.854M (± 0.7%) i/s -    108.762M in   5.002198s
                   with 95.0% confidence

Comparison:
                  !!: 42487427.1 i/s
              nil !=: 38312618.0 i/s - 1.11x  (± 0.01) slower
               !nil?: 31078123.9 i/s - 1.37x  (± 0.01) slower
            present?: 21854143.8 i/s - 1.94x  (± 0.02) slower
                   with 95.0% confidence
```

#### #<Object:0x00007f9c0a968310>

```
Warming up --------------------------------------
                  !!   328.432k i/100ms
               !nil?   307.084k i/100ms
              nil !=   324.749k i/100ms
            present?   261.758k i/100ms
Calculating -------------------------------------
                  !!     40.897M (± 0.5%) i/s -    203.628M in   5.005426s
               !nil?     30.242M (± 0.6%) i/s -    150.471M in   5.000563s
              nil !=     39.610M (± 0.6%) i/s -    197.123M in   5.005610s
            present?     12.163M (± 0.8%) i/s -     60.728M in   5.011771s
                   with 95.0% confidence

Comparison:
                  !!: 40897495.2 i/s
              nil !=: 39610078.3 i/s - 1.03x  (± 0.01) slower
               !nil?: 30242403.1 i/s - 1.35x  (± 0.01) slower
            present?: 12162705.7 i/s - 3.36x  (± 0.03) slower
                   with 95.0% confidence
```

#### Empty array `nil` comparison

```
Warming up --------------------------------------
              != nil   326.024k i/100ms
              nil !=   270.805k i/100ms
Calculating -------------------------------------
              != nil     40.133M (± 0.5%) i/s -    199.853M in   5.004102s
              nil !=     11.551M (± 0.9%) i/s -     57.681M in   5.020992s
                   with 95.0% confidence

Comparison:
              != nil: 40133046.7 i/s
              nil !=: 11551012.8 i/s - 3.47x  (± 0.04) slower
                   with 95.0% confidence
```
