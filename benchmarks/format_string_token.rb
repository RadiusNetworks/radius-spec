# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/format_string_token.rb
require_relative 'bm_setup'

display_benchmark_header

SINGLE_TOKEN_HASH = { greeting: 'Hello' }.freeze
MULTI_TOKEN_HASH = {
  greeting: 'Hello',
  name: 'Benchmark',
  message: 'Always a good idea to benchmark',
}.freeze

# rubocop:disable Style/FormatStringToken
section "Format String Token (single token - inline token hash)" do |bench|
  bench.report("annotated") do
    format '%<greeting>s', greeting: 'Hello'
  end

  bench.report("template") do
    format '%{greeting}', greeting: 'Hello'
  end

  bench.report("unannotated") do
    format '%s', 'Hello'
  end
end

section "Format String Token (single token - constant token hash)" do |bench|
  bench.report("annotated") do
    format '%<greeting>s', SINGLE_TOKEN_HASH
  end

  bench.report("template") do
    format '%{greeting}', SINGLE_TOKEN_HASH
  end

  bench.report("unannotated") do
    format '%s', 'Hello'
  end
end

section "Format String Token (multiple tokens - constant token hash)" do |bench|
  bench.report("annotated") do
    format '%<greeting>s %<name>s, %<message>s!', MULTI_TOKEN_HASH
  end

  bench.report("template") do
    format '%{greeting} %{name}, %{message}!', MULTI_TOKEN_HASH
  end

  bench.report("unannotated") do
    format '%s %s, %s', 'Hello', 'Benchmark!', 'Always a good idea to benchmark'
  end
end
# rubocop:enable Style/FormatStringToken

section "Format String Token (annotated)" do |bench|
  bench.report("inline hash") do
    format '%<greeting>s', greeting: 'Hello'
  end

  bench.report("constant hash") do
    format '%<greeting>s', SINGLE_TOKEN_HASH
  end
end

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Format String Token (single token - inline token hash)

```
Warming up --------------------------------------
           annotated    88.435k i/100ms
            template    87.693k i/100ms
         unannotated   173.134k i/100ms
Calculating -------------------------------------
           annotated      1.160M (± 1.3%) i/s -      5.837M in   5.044452s
            template      1.188M (± 1.2%) i/s -      5.963M in   5.031961s
         unannotated      3.053M (± 0.8%) i/s -     15.409M in   5.055505s
                   with 95.0% confidence

Comparison:
         unannotated:  3053228.5 i/s
            template:  1187997.4 i/s - 2.57x  (± 0.04) slower
           annotated:  1160462.9 i/s - 2.63x  (± 0.04) slower
                   with 95.0% confidence
```

#### Format String Token (single token - constant token hash)

```
Warming up --------------------------------------
           annotated   142.944k i/100ms
            template   142.146k i/100ms
         unannotated   178.653k i/100ms
Calculating -------------------------------------
           annotated      2.155M (± 0.8%) i/s -     10.864M in   5.048122s
            template      2.158M (± 1.0%) i/s -     10.803M in   5.016911s
         unannotated      3.081M (± 0.8%) i/s -     15.543M in   5.053055s
                   with 95.0% confidence

Comparison:
         unannotated:  3080897.8 i/s
            template:  2157563.3 i/s - 1.43x  (± 0.02) slower
           annotated:  2155420.1 i/s - 1.43x  (± 0.02) slower
                   with 95.0% confidence
```

#### Format String Token (multiple tokens - constant token hash)

```
Warming up --------------------------------------
           annotated    69.462k i/100ms
            template    59.389k i/100ms
         unannotated    57.845k i/100ms
Calculating -------------------------------------
           annotated    890.828k (± 3.4%) i/s -      4.307M in   5.042996s
            template    885.637k (± 2.8%) i/s -      4.276M in   5.017872s
         unannotated      1.343M (± 3.8%) i/s -      6.189M in   5.104055s
                   with 95.0% confidence

Comparison:
         unannotated:  1342803.3 i/s
           annotated:   890828.1 i/s - 1.51x  (± 0.08) slower
            template:   885637.5 i/s - 1.52x  (± 0.07) slower
                   with 95.0% confidence
```

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Format String Token (annotated)

```
Warming up --------------------------------------
         inline hash    91.059k i/100ms
       constant hash   135.572k i/100ms
Calculating -------------------------------------
         inline hash      1.218M (± 1.2%) i/s -      6.101M in   5.024187s
       constant hash      2.135M (± 1.0%) i/s -     10.710M in   5.028115s
                   with 95.0% confidence

Comparison:
       constant hash:  2135050.5 i/s
         inline hash:  1217810.2 i/s - 1.75x  (± 0.03) slower
                   with 95.0% confidence
```
