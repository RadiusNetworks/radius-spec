# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/case_equality_vs_class_check.rb
require_relative 'bm_setup'

display_benchmark_header

section "Class match" do |bench|
  x = "Any String"

  bench.report("===") do
    String === x # rubocop:disable Style/CaseEquality
  end

  bench.report("is_a?") do
    x.is_a?(String)
  end
end

section "Class NO match" do |bench|
  x = :any_symbol

  bench.report("===") do
    String === x # rubocop:disable Style/CaseEquality
  end

  bench.report("is_a?") do
    x.is_a?(String)
  end
end

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: true

### Test Cases

#### Class match

```
Warming up --------------------------------------
                 ===   284.703k i/100ms
               is_a?   280.367k i/100ms
Calculating -------------------------------------
                 ===     11.394M (± 0.8%) i/s -     56.941M in   5.014392s
               is_a?     11.068M (± 0.8%) i/s -     55.232M in   5.007549s
                   with 95.0% confidence

Comparison:
                 ===: 11394313.8 i/s
               is_a?: 11068062.4 i/s - 1.03x  (± 0.01) slower
                   with 95.0% confidence
```

#### Class NO match

```
Warming up --------------------------------------
                 ===   298.288k i/100ms
               is_a?   290.294k i/100ms
Calculating -------------------------------------
                 ===     10.567M (± 0.7%) i/s -     52.797M in   5.007023s
               is_a?     10.405M (± 0.7%) i/s -     51.963M in   5.006983s
                   with 95.0% confidence

Comparison:
                 ===: 10567130.4 i/s
               is_a?: 10405382.6 i/s - 1.02x  (± 0.01) slower
                   with 95.0% confidence
```
