# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/empty_literal.rb
require_relative 'bm_setup'

display_benchmark_header

# rubocop:disable Style/EmptyLiteral
section "[] vs Array.new" do |bench|
  bench.report("Array.new") do
    Array.new
    nil
  end

  bench.report("[]") do
    []
    nil
  end
end

section "{} vs Hash.new" do |bench|
  bench.report("Hash.new") do
    Hash.new
    nil
  end

  bench.report("{}") do
    {}
    nil
  end
end
# rubocop:enable Style/EmptyLiteral

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### [] vs Array.new

```
Warming up --------------------------------------
           Array.new   238.371k i/100ms
                  []   336.249k i/100ms
Calculating -------------------------------------
           Array.new      6.298M (± 1.0%) i/s -     31.465M in   5.014660s
                  []     14.157M (± 0.8%) i/s -     70.612M in   5.004166s
                   with 95.0% confidence

Comparison:
                  []: 14157286.9 i/s
           Array.new:  6297668.8 i/s - 2.25x  (± 0.03) slower
                   with 95.0% confidence
```

#### {} vs Hash.new

```
Warming up --------------------------------------
            Hash.new   140.548k i/100ms
                  {}   348.340k i/100ms
Calculating -------------------------------------
            Hash.new      2.203M (± 1.1%) i/s -     11.103M in   5.056212s
                  {}     14.285M (± 0.6%) i/s -     71.410M in   5.010915s
                   with 95.0% confidence

Comparison:
                  {}: 14285184.2 i/s
            Hash.new:  2202622.4 i/s - 6.49x  (± 0.08) slower
                   with 95.0% confidence
```
