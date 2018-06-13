# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/delete_vs_tr.rb
require_relative 'bm_setup'

display_benchmark_header

[
  ["No Removal",         "Any String Chars", "m",   ""],
  ["Single Removal",     "Any String Chars", "i",   ""],
  ["Multiple Removal",   "Any String Chars", "n",   ""],
  ["Multi-Char Removal", "Any String Chars", "nar", ""],
].each do |title, str, pattern, replacement|
  section title do |bench|
    bench.report("delete") do
      str.delete(pattern)
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

#### No Removal

```
Warming up --------------------------------------
              delete   164.989k i/100ms
                  tr   163.504k i/100ms
Calculating -------------------------------------
              delete      2.578M (± 0.9%) i/s -     13.034M in   5.065099s
                  tr      2.566M (± 0.8%) i/s -     12.917M in   5.039546s
                   with 95.0% confidence

Comparison:
              delete:  2578043.5 i/s
                  tr:  2565794.9 i/s - same-ish: difference falls within error
                   with 95.0% confidence
```

#### Single Removal

```
Warming up --------------------------------------
              delete   169.321k i/100ms
                  tr   173.594k i/100ms
Calculating -------------------------------------
              delete      2.779M (± 1.1%) i/s -     13.884M in   5.010559s
                  tr      2.721M (± 1.0%) i/s -     13.714M in   5.050566s
                   with 95.0% confidence

Comparison:
              delete:  2778762.2 i/s
                  tr:  2721121.1 i/s - 1.02x  (± 0.02) slower
                   with 95.0% confidence
```

#### Multiple Removal

```
Warming up --------------------------------------
              delete   173.074k i/100ms
                  tr   171.824k i/100ms
Calculating -------------------------------------
              delete      2.804M (± 1.0%) i/s -     14.019M in   5.009616s
                  tr      2.739M (± 1.0%) i/s -     13.746M in   5.030533s
                   with 95.0% confidence

Comparison:
              delete:  2804348.9 i/s
                  tr:  2739399.1 i/s - 1.02x  (± 0.01) slower
                   with 95.0% confidence
```

#### Multi-Char Removal

```
Warming up --------------------------------------
              delete   165.485k i/100ms
                  tr   158.961k i/100ms
Calculating -------------------------------------
              delete      2.547M (± 1.3%) i/s -     12.742M in   5.019971s
                  tr      2.507M (± 1.0%) i/s -     12.558M in   5.018688s
                   with 95.0% confidence

Comparison:
              delete:  2547442.6 i/s
                  tr:  2507427.2 i/s - same-ish: difference falls within error
                   with 95.0% confidence
```
