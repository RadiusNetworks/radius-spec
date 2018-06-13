# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/max_ternary_micro.rb
require_relative 'bm_setup'

display_benchmark_header

section "Min First" do |bench|
  x = 1
  y = 2

  bench.report("max") do |times|
    i = 0
    while i < times
      [x, y].max
      i += 1
    end
  end

  bench.report("ternary") do |times|
    i = 0
    while i < times
      (x < y) ? y : x
      i += 1
    end
  end
end

section "Max First" do |bench|
  x = 2
  y = 1

  bench.report("max") do |times|
    i = 0
    while i < times
      [x, y].max
      i += 1
    end
  end

  bench.report("ternary") do |times|
    i = 0
    while i < times
      (x < y) ? y : x
      i += 1
    end
  end
end

section "Equal values" do |bench|
  x = 2
  y = 2

  bench.report("max") do |times|
    i = 0
    while i < times
      [x, y].max
      i += 1
    end
  end

  bench.report("ternary") do |times|
    i = 0
    while i < times
      (x < y) ? y : x
      i += 1
    end
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
                 max   318.262k i/100ms
             ternary   330.711k i/100ms
Calculating -------------------------------------
                 max     38.997M (± 0.6%) i/s -    193.822M in   5.001947s
             ternary     48.280M (± 0.5%) i/s -    240.096M in   5.002313s
                   with 95.0% confidence

Comparison:
             ternary: 48279773.6 i/s
                 max: 38996762.1 i/s - 1.24x  (± 0.01) slower
                   with 95.0% confidence
```

#### Max First

```
Warming up --------------------------------------
                 max   336.333k i/100ms
             ternary   344.267k i/100ms
Calculating -------------------------------------
                 max     38.699M (± 0.7%) i/s -    192.046M in   5.000931s
             ternary     50.601M (± 0.6%) i/s -    251.315M in   5.002150s
                   with 95.0% confidence

Comparison:
             ternary: 50601023.9 i/s
                 max: 38699482.7 i/s - 1.31x  (± 0.01) slower
                   with 95.0% confidence
```

#### Equal values

```
Warming up --------------------------------------
                 max   331.543k i/100ms
             ternary   342.686k i/100ms
Calculating -------------------------------------
                 max     39.661M (± 0.6%) i/s -    197.268M in   5.004271s
             ternary     47.147M (± 0.5%) i/s -    234.740M in   5.006089s
                   with 95.0% confidence

Comparison:
             ternary: 47147208.6 i/s
                 max: 39660659.9 i/s - 1.19x  (± 0.01) slower
                   with 95.0% confidence
```
