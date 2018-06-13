# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/cover_vs_include.rb
require_relative 'bm_setup'

display_benchmark_header

INT_RANGE = (0..15)
INT_VAR = 10

section "Integer ranges" do |bench|
  bench.report('range#cover?') do
    INT_RANGE.cover?(INT_VAR)
  end

  bench.report('range#include?') do
    INT_RANGE.include?(INT_VAR)
  end

  bench.report('range#member?') do
    INT_RANGE.member?(INT_VAR)
  end

  bench.report('plain compare') do
    0 < INT_VAR && INT_VAR < 15
  end
end

BEGIN_OF_JULY = Time.utc(2015, 7, 1)
END_OF_JULY = Time.utc(2015, 7, 31)
DAY_IN_JULY = Time.utc(2015, 7, 15)

TIME_RANGE = (BEGIN_OF_JULY..END_OF_JULY)

section "Time ranges" do |bench|
  bench.report('range#cover?') do
    TIME_RANGE.cover?(DAY_IN_JULY)
  end

  bench.report('range#include?') do
    TIME_RANGE.include?(DAY_IN_JULY)
  end

  bench.report('range#member?') do
    TIME_RANGE.member?(DAY_IN_JULY)
  end

  bench.report('plain compare') do
    BEGIN_OF_JULY < DAY_IN_JULY && DAY_IN_JULY < END_OF_JULY
  end
end

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Integer ranges

```
Warming up --------------------------------------
        range#cover?   247.959k i/100ms
      range#include?   251.846k i/100ms
       range#member?   251.416k i/100ms
       plain compare   305.858k i/100ms
Calculating -------------------------------------
        range#cover?      6.400M (± 0.8%) i/s -     31.987M in   5.008881s
      range#include?      6.328M (± 0.8%) i/s -     31.733M in   5.025377s
       range#member?      6.366M (± 0.6%) i/s -     31.930M in   5.022146s
       plain compare     11.042M (± 0.8%) i/s -     55.054M in   4.999666s
                   with 95.0% confidence

Comparison:
       plain compare: 11041684.3 i/s
        range#cover?:  6399832.9 i/s - 1.73x  (± 0.02) slower
       range#member?:  6366323.6 i/s - 1.73x  (± 0.02) slower
      range#include?:  6327682.0 i/s - 1.75x  (± 0.02) slower
                   with 95.0% confidence
```

#### Time ranges

```
Warming up --------------------------------------
        range#cover?   249.380k i/100ms
      range#include?   247.775k i/100ms
       range#member?   247.446k i/100ms
       plain compare   223.517k i/100ms
Calculating -------------------------------------
        range#cover?      5.942M (± 0.7%) i/s -     29.676M in   5.002164s
      range#include?      5.724M (± 0.7%) i/s -     28.742M in   5.028509s
       range#member?      5.771M (± 0.7%) i/s -     28.951M in   5.024809s
       plain compare      4.751M (± 0.9%) i/s -     23.916M in   5.046978s
                   with 95.0% confidence

Comparison:
        range#cover?:  5941582.8 i/s
       range#member?:  5770708.7 i/s - 1.03x  (± 0.01) slower
      range#include?:  5723795.5 i/s - 1.04x  (± 0.01) slower
       plain compare:  4750545.5 i/s - 1.25x  (± 0.01) slower
                   with 95.0% confidence
```
