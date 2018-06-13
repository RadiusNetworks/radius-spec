# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/unfreeze_string.rb
require_relative 'bm_setup'

display_benchmark_header

# rubocop:disable Performance/UnfreezeString
section "Unfreezing empty string" do |bench|
  bench.report("String.new") do
    String.new
  end

  bench.report("+") do
    +""
  end

  bench.report("dup") do
    "".dup
  end
end

STRING = "Any String"
section "Unfreezing string" do |bench|
  bench.report("String.new") do
    String.new(STRING)
  end

  bench.report("+") do
    +STRING
  end

  bench.report("dup") do
    STRING.dup
  end
end
# rubocop:enable Performance/UnfreezeString

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Unfreezing empty string

```
Warming up --------------------------------------
          String.new   262.027k i/100ms
                   +   286.997k i/100ms
                 dup   217.963k i/100ms
Calculating -------------------------------------
          String.new      6.791M (± 0.9%) i/s -     34.064M in   5.029927s
                   +      8.811M (± 1.1%) i/s -     43.911M in   5.011455s
                 dup      4.627M (± 1.0%) i/s -     23.104M in   5.007394s
                   with 95.0% confidence

Comparison:
                   +:  8810714.9 i/s
          String.new:  6791074.6 i/s - 1.30x  (± 0.02) slower
                 dup:  4626875.0 i/s - 1.90x  (± 0.03) slower
                   with 95.0% confidence
```

#### Unfreezing string

```
Warming up --------------------------------------
          String.new   220.258k i/100ms
                   +   287.795k i/100ms
                 dup   214.192k i/100ms
Calculating -------------------------------------
          String.new      4.624M (± 0.8%) i/s -     23.127M in   5.010887s
                   +      8.946M (± 0.9%) i/s -     44.608M in   5.001680s
                 dup      4.513M (± 0.9%) i/s -     22.704M in   5.041383s
                   with 95.0% confidence

Comparison:
                   +:  8946340.5 i/s
          String.new:  4624267.9 i/s - 1.93x  (± 0.02) slower
                 dup:  4513230.8 i/s - 1.98x  (± 0.02) slower
                   with 95.0% confidence
```
