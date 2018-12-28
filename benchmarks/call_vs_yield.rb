# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/call_vs_yield.rb
require_relative 'bm_setup'

display_benchmark_header

# rubocop:disable Performance/RedundantBlockCall
def block_call(&block)
  block.call
end

def block_yield(&_block)
  yield
end

def block_arg(&_block)
  1 + 1 # Always do the same amount of work
end

def no_arg_yield
  yield
end

def pass_through(&block)
  no_arg_yield(&block)
end

section "Block call vs yield" do |bench|
  bench.report("block.call") do |times|
    i = 0
    while i < times
      block_call do
        1 + 1
      end
      i += 1
    end
  end

  bench.report("block yield") do |times|
    i = 0
    while i < times
      block_yield do
        1 + 1
      end
      i += 1
    end
  end

  bench.report("block arg only") do |times|
    i = 0
    while i < times
      block_arg do
        1 + 1
      end
      i += 1
    end
  end

  bench.report("no arg yield") do |times|
    i = 0
    while i < times
      no_arg_yield do
        1 + 1
      end
      i += 1
    end
  end

  bench.report("pass through block") do |times|
    i = 0
    while i < times
      pass_through do
        1 + 1
      end
      i += 1
    end
  end
end
# rubocop:enable Performance/RedundantBlockCall

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Block call vs yield

```
Warming up --------------------------------------
          block.call   117.672k i/100ms
         block yield   272.613k i/100ms
      block arg only   287.821k i/100ms
        no arg yield   286.217k i/100ms
  pass through block   251.757k i/100ms
Calculating -------------------------------------
          block.call      3.181M (± 0.9%) i/s -     15.886M in   5.010444s
         block yield     14.017M (± 0.7%) i/s -     70.062M in   5.015163s
      block arg only     17.835M (± 0.7%) i/s -     88.937M in   5.011243s
        no arg yield     18.056M (± 0.6%) i/s -     90.158M in   5.010075s
  pass through block     10.776M (± 0.8%) i/s -     53.876M in   5.019221s
                   with 95.0% confidence

Comparison:
        no arg yield: 18056296.4 i/s
      block arg only: 17835047.6 i/s - same-ish: difference falls within error
         block yield: 14017426.6 i/s - 1.29x  (± 0.01) slower
  pass through block: 10776151.4 i/s - 1.68x  (± 0.02) slower
          block.call:  3180610.0 i/s - 5.68x  (± 0.06) slower
                   with 95.0% confidence
```

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: true

### Test Cases

#### Block call vs yield

```
Warming up --------------------------------------
          block.call   134.623k i/100ms
         block yield   276.955k i/100ms
      block arg only   306.377k i/100ms
        no arg yield   286.201k i/100ms
  pass through block   259.025k i/100ms
Calculating -------------------------------------
          block.call      3.558M (± 2.6%) i/s -     17.097M in   5.033155s
         block yield     14.469M (± 0.7%) i/s -     72.285M in   5.013029s
      block arg only     18.173M (± 0.6%) i/s -     90.688M in   5.005679s
        no arg yield     18.207M (± 0.6%) i/s -     90.726M in   5.001766s
  pass through block     10.794M (± 0.8%) i/s -     53.877M in   5.010781s
                   with 95.0% confidence

Comparison:
        no arg yield: 18206595.2 i/s
      block arg only: 18172764.0 i/s - same-ish: difference falls within error
         block yield: 14469142.9 i/s - 1.26x  (± 0.01) slower
  pass through block: 10793657.6 i/s - 1.69x  (± 0.02) slower
          block.call:  3557929.5 i/s - 5.12x  (± 0.14) slower
                   with 95.0% confidence
```

### Environment

ruby 2.6.0p0 (2018-12-25 revision 66547) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Block call vs yield

```
Warming up --------------------------------------
          block.call   252.830k i/100ms
         block yield   266.647k i/100ms
      block arg only   275.856k i/100ms
        no arg yield   271.677k i/100ms
  pass through block   251.117k i/100ms
Calculating -------------------------------------
          block.call     11.729M (± 0.9%) i/s -     58.404M in   5.004905s
         block yield     13.216M (± 0.8%) i/s -     65.862M in   5.007922s
      block arg only     17.288M (± 0.9%) i/s -     86.067M in   5.009110s
        no arg yield     16.109M (± 0.9%) i/s -     80.145M in   5.006225s
  pass through block     10.175M (± 1.0%) i/s -     50.726M in   5.010616s
                   with 95.0% confidence

Comparison:
      block arg only: 17287836.2 i/s
        no arg yield: 16108506.9 i/s - 1.07x  (± 0.01) slower
         block yield: 13215609.2 i/s - 1.31x  (± 0.02) slower
          block.call: 11729199.4 i/s - 1.47x  (± 0.02) slower
  pass through block: 10174648.1 i/s - 1.70x  (± 0.02) slower
                   with 95.0% confidence
```
