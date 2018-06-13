# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/max_ternary.rb
require_relative 'bm_setup'

display_benchmark_header

section "Min First" do |bench|
  x = 1
  y = 2

  bench.report("max") do
    [x, y].max
  end

  bench.report("ternary") do
    (x < y) ? y : x
  end
end

section "Max First" do |bench|
  x = 2
  y = 1

  bench.report("max") do
    [x, y].max
  end

  bench.report("ternary") do
    (x < y) ? y : x
  end
end

section "Equal values" do
  x = 2
  y = 2

  bench.report("max") do
    [x, y].max
  end

  bench.report("ternary") do
    (x < y) ? y : x
  end
end

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Min First

```
Warming up --------------------------------------
                 max   349.454k i/100ms
             ternary   349.128k i/100ms
Calculating -------------------------------------
                 max     12.628M (± 0.9%) i/s -     62.902M in   5.000232s
             ternary     12.853M (± 0.8%) i/s -     64.240M in   5.015540s
                   with 95.0% confidence

Comparison:
             ternary: 12852607.6 i/s
                 max: 12628052.1 i/s - 1.02x  (± 0.01) slower
                   with 95.0% confidence
```

#### Max First

```
Warming up --------------------------------------
                 max   346.104k i/100ms
             ternary   344.003k i/100ms
Calculating -------------------------------------
                 max     12.788M (± 0.7%) i/s -     64.029M in   5.022073s
             ternary     12.607M (± 0.7%) i/s -     62.953M in   5.006764s
                   with 95.0% confidence

Comparison:
                 max: 12787891.5 i/s
             ternary: 12606659.1 i/s - same-ish: difference falls within error
                   with 95.0% confidence
```

#### Equal values

```
Warming up --------------------------------------
                 max   340.468k i/100ms
             ternary   343.788k i/100ms
Calculating -------------------------------------
                 max     12.278M (± 0.9%) i/s -     61.284M in   5.010572s
             ternary     12.703M (± 0.9%) i/s -     63.601M in   5.026552s
                   with 95.0% confidence

Comparison:
             ternary: 12702775.1 i/s
                 max: 12277915.1 i/s - 1.03x  (± 0.01) slower
                   with 95.0% confidence
```
