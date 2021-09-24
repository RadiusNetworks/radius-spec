# frozen_string_literal: true

# Data values are taken from the Rubocop Style/HashLikeCase example
#
# https://docs.rubocop.org/rubocop/1.21/cops_style.html#styleredundantfileextensioninrequire

# Run from the command line: bundle exec ruby benchmarks/style_hash_like_case.rb
require_relative 'bm_setup'

display_benchmark_header

# rubocop:disable Style/HashLikeCase
def case_check3(value)
  case value
  when 'europe'
    'http://eu.example.com'
  when 'america'
    'http://us.example.com'
  when 'australia'
    'http://au.example.com'
  end
end

HASH_CASE3 = {
  'europe' => 'http://eu.example.com',
  'america' => 'http://us.example.com',
  'australia' => 'http://au.example.com',
}.freeze

def hash_check3(value)
  HASH_CASE3[value]
end

section "Style/HashLikeCase(3) - First Match" do |bench|
  bench.report("case") do |times|
    i = 0
    while i < times
      case_check3('europe')
      i += 1
    end
  end

  bench.report("hash") do |times|
    i = 0
    while i < times
      hash_check3('europe')
      i += 1
    end
  end
end

section "Style/HashLikeCase(3) - Last Match" do |bench|
  bench.report("case") do |times|
    i = 0
    while i < times
      case_check3('australia')
      i += 1
    end
  end

  bench.report("hash") do |times|
    i = 0
    while i < times
      hash_check3('australia')
      i += 1
    end
  end
end

section "Style/HashLikeCase(3) - No Match" do |bench|
  bench.report("case") do |times|
    i = 0
    while i < times
      case_check3('any other place')
      i += 1
    end
  end

  bench.report("hash") do |times|
    i = 0
    while i < times
      hash_check3('any other place')
      i += 1
    end
  end
end

def case_check5(value) # rubocop:disable Metrics/MethodLength
  case value
  when 'europe'
    'http://eu.example.com'
  when 'america'
    'http://us.example.com'
  when 'australia'
    'http://au.example.com'
  when 'china'
    'http://cn.example.com'
  when 'japan'
    'http://jp.example.com'
  end
end

HASH_CASE5 = {
  'europe' => 'http://eu.example.com',
  'america' => 'http://us.example.com',
  'australia' => 'http://au.example.com',
  'china' => 'http://cn.example.com',
  'japan' => 'http://jp.example.com',
}.freeze

def hash_check5(value)
  HASH_CASE5[value]
end

section "Style/HashLikeCase(5) - First Match" do |bench|
  bench.report("case") do |times|
    i = 0
    while i < times
      case_check5('europe')
      i += 1
    end
  end

  bench.report("hash") do |times|
    i = 0
    while i < times
      hash_check5('europe')
      i += 1
    end
  end
end

section "Style/HashLikeCase(5) - Last Match" do |bench|
  bench.report("case") do |times|
    i = 0
    while i < times
      case_check5('japan')
      i += 1
    end
  end

  bench.report("hash") do |times|
    i = 0
    while i < times
      hash_check5('japan')
      i += 1
    end
  end
end

section "Style/HashLikeCase(5) - No Match" do |bench|
  bench.report("case") do |times|
    i = 0
    while i < times
      case_check5('any other place')
      i += 1
    end
  end

  bench.report("hash") do |times|
    i = 0
    while i < times
      hash_check5('any other place')
      i += 1
    end
  end
end

# rubocop:enable Style/HashLikeCase

__END__

Usage of `case` appears to be more performant than a hash. However, both are
highly performant, so any difference is likely negligible compared to other
performance issues.

### Environment

Performance-M Dyno
ruby 2.7.4p191 (2021-07-07 revision a21a3b7d23) [x86_64-linux]
GC Disabled: true

### Test Cases

#### Style/HashLikeCase(3) - First Match

```
Warming up --------------------------------------
                case     1.768M i/100ms
                hash     1.710M i/100ms
Calculating -------------------------------------
                case     17.630M (± 0.3%) i/s -     88.418M in   5.016811s
                hash     17.044M (± 0.2%) i/s -     85.504M in   5.017564s
                   with 95.0% confidence

Comparison:
                case: 17630438.8 i/s
                hash: 17044158.0 i/s - 1.03x  (± 0.00) slower
                   with 95.0% confidence
```

#### Style/HashLikeCase(3) - Last Match

```
Warming up --------------------------------------
                case     1.714M i/100ms
                hash     1.644M i/100ms
Calculating -------------------------------------
                case     17.066M (± 0.7%) i/s -     85.718M in   5.027638s
                hash     16.432M (± 0.1%) i/s -     82.205M in   5.002925s
                   with 95.0% confidence

Comparison:
                case: 17066448.1 i/s
                hash: 16432193.1 i/s - 1.04x  (± 0.01) slower
                   with 95.0% confidence
```

#### Style/HashLikeCase(3) - No Match

```
Warming up --------------------------------------
                case     1.706M i/100ms
                hash     1.529M i/100ms
Calculating -------------------------------------
                case     16.944M (± 0.8%) i/s -     85.300M in   5.041700s
                hash     15.210M (± 0.5%) i/s -     76.428M in   5.028693s
                   with 95.0% confidence

Comparison:
                case: 16944279.7 i/s
                hash: 15210481.2 i/s - 1.11x  (± 0.01) slower
                   with 95.0% confidence
```

#### Style/HashLikeCase(5) - First Match

```
Warming up --------------------------------------
                case     1.738M i/100ms
                hash     1.704M i/100ms
Calculating -------------------------------------
                case     17.621M (± 0.5%) i/s -     88.642M in   5.033716s
                hash     16.963M (± 0.5%) i/s -     85.198M in   5.025691s
                   with 95.0% confidence

Comparison:
                case: 17621070.3 i/s
                hash: 16963331.9 i/s - 1.04x  (± 0.01) slower
                   with 95.0% confidence
```

#### Style/HashLikeCase(5) - Last Match

```
Warming up --------------------------------------
                case     1.718M i/100ms
                hash     1.634M i/100ms
Calculating -------------------------------------
                case     17.170M (± 0.0%) i/s -     85.898M in   5.002845s
                hash     16.357M (± 0.3%) i/s -     83.338M in   5.097011s
                   with 95.0% confidence

Comparison:
                case: 17170019.6 i/s
                hash: 16356675.5 i/s - 1.05x  (± 0.00) slower
                   with 95.0% confidence
```

#### Style/HashLikeCase(5) - No Match

```
Warming up --------------------------------------
                case     1.661M i/100ms
                hash     1.501M i/100ms
Calculating -------------------------------------
                case     16.518M (± 0.6%) i/s -     83.046M in   5.031835s
                hash     14.963M (± 0.5%) i/s -     75.058M in   5.019838s
                   with 95.0% confidence

Comparison:
                case: 16517985.2 i/s
                hash: 14962803.1 i/s - 1.10x  (± 0.01) slower
                   with 95.0% confidence
```
