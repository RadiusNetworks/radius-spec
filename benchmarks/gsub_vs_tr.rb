# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/gsub_vs_tr.rb
require_relative 'bm_setup'

display_benchmark_header

[
  ["No Replacement",       "Any String", "m", /m/, "-"],
  ["Single Replacement",   "Any String", "i", /i/, "-"],
  ["Multiple Replacement", "Any String", "n", /n/, "-"],
].each do |title, str, pattern, regexp, replacement|
  section title do |bench|
    bench.report("gsub(string)") do
      str.gsub(pattern, replacement)
    end

    bench.report("gsub(regexp)") do
      str.gsub(regexp, replacement)
    end

    bench.report("tr") do
      str.tr(pattern, replacement)
    end
  end
end

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### No Replacement

```
Warming up --------------------------------------
        gsub(string)   225.903k i/100ms
        gsub(regexp)   150.469k i/100ms
                  tr   225.874k i/100ms
Calculating -------------------------------------
        gsub(string)      4.848M (± 0.7%) i/s -     24.398M in   5.042073s
        gsub(regexp)      2.558M (± 1.3%) i/s -     12.790M in   5.018370s
                  tr      4.872M (± 1.0%) i/s -     24.394M in   5.020983s
                   with 95.0% confidence

Comparison:
                  tr:  4872264.7 i/s
        gsub(string):  4847903.4 i/s - same-ish: difference falls within error
        gsub(regexp):  2557821.1 i/s - 1.91x  (± 0.03) slower
                   with 95.0% confidence
```

#### Single Replacement

```
Warming up --------------------------------------
        gsub(string)   115.202k i/100ms
        gsub(regexp)    64.609k i/100ms
                  tr   230.643k i/100ms
Calculating -------------------------------------
        gsub(string)      1.431M (± 1.6%) i/s -      7.143M in   5.010792s
        gsub(regexp)    663.965k (± 1.0%) i/s -      3.360M in   5.067248s
                  tr      4.517M (± 0.9%) i/s -     22.603M in   5.014505s
                   with 95.0% confidence

Comparison:
                  tr:  4516906.0 i/s
        gsub(string):  1430926.3 i/s - 3.16x  (± 0.06) slower
        gsub(regexp):   663964.7 i/s - 6.80x  (± 0.09) slower
                   with 95.0% confidence
```

#### Multiple Replacement

```
Warming up --------------------------------------
        gsub(string)    92.833k i/100ms
        gsub(regexp)    51.482k i/100ms
                  tr   222.779k i/100ms
Calculating -------------------------------------
        gsub(string)      1.263M (± 1.3%) i/s -      6.313M in   5.014495s
        gsub(regexp)    663.557k (± 1.4%) i/s -      3.346M in   5.061408s
                  tr      4.786M (± 0.9%) i/s -     24.060M in   5.040074s
                   with 95.0% confidence

Comparison:
                  tr:  4785813.8 i/s
        gsub(string):  1262609.0 i/s - 3.79x  (± 0.06) slower
        gsub(regexp):   663557.0 i/s - 7.21x  (± 0.12) slower
                   with 95.0% confidence
```
