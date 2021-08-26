# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/hash_merge.rb
require_relative 'bm_setup'

# rubocop:disable Style/HashEachMethods

display_benchmark_header

# Bad per Rubocop
def hash_keys_each(hash)
  hash.keys.each { |k| k + 1 }

  # Return nil to avoid array creation penalty which may skew benchmark
  nil
end

# Good per Rubocop
def hash_each_key(hash)
  hash.each_key { |k| k + 1 }

  # Return nil to avoid array creation penalty which may skew benchmark
  nil
end

[
  [],
  (1..5),
  (1..10),
  (1..20),
  (1..100),
  (1..500),
].each do |data|
  test_hash = data.zip(data).to_h

  section "Hash key enumeration (size=#{data.size})" do |bench|
    bench.report("Hash.keys.each") do
      hash_keys_each(test_hash)
    end

    bench.report("Hash.each_key") do
      hash_each_key(test_hash)
    end
  end
end

# Bad per Rubocop
def hash_values_each(hash)
  hash.values.each { |v| v + 1 }

  # Return nil to avoid array creation penalty which may skew benchmark
  nil
end

# Good per Rubocop
def hash_each_value(hash)
  hash.each_value { |v| v + 1 }

  # Return nil to avoid array creation penalty which may skew benchmark
  nil
end

[
  [],
  (1..5),
  (1..10),
  (1..20),
  (1..100),
  (1..500),
].each do |data|
  test_hash = data.zip(data).to_h

  section "Hash value enumeration (size=#{data.size})" do |bench|
    bench.report("Hash.values.each") do
      hash_values_each(test_hash)
    end

    bench.report("Hash.each_value") do
      hash_each_value(test_hash)
    end
  end
end

# rubocop:enable Style/HashEachMethods

__END__

### Environment

Heroku Performance-L Dyno

ruby 2.7.3p183 (2021-04-05 revision 6847ee089d) [x86_64-linux]
GC Disabled: false

### Test Cases

Behavior for the keys and value enumerations is roughly equivalent. As
hypothesized the `each_xyz` versions are faster. What is surprising is that the
performance difference drops off drastically the larger the hash, even for
small hash sizes. Basically, once the hash reaches 10 times, the performance
gains are constant after that point (around 1 - 4%).

#### Hash key enumeration (size=0)

```
Warming up --------------------------------------
      Hash.keys.each   913.942k i/100ms
       Hash.each_key     1.376M i/100ms
Calculating -------------------------------------
      Hash.keys.each      9.167M (± 0.0%) i/s -     46.611M in   5.084564s
       Hash.each_key     13.734M (± 0.2%) i/s -     68.779M in   5.008581s
                   with 95.0% confidence

Comparison:
       Hash.each_key: 13734476.7 i/s
      Hash.keys.each:  9167168.9 i/s - 1.50x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash key enumeration (size=5)

```
Warming up --------------------------------------
      Hash.keys.each   319.678k i/100ms
       Hash.each_key   360.081k i/100ms
Calculating -------------------------------------
      Hash.keys.each      3.190M (± 0.4%) i/s -     15.984M in   5.012434s
       Hash.each_key      3.596M (± 0.0%) i/s -     18.004M in   5.006636s
                   with 95.0% confidence

Comparison:
       Hash.each_key:  3596043.0 i/s
      Hash.keys.each:  3189893.5 i/s - 1.13x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash key enumeration (size=10)

```
Warming up --------------------------------------
      Hash.keys.each   201.546k i/100ms
       Hash.each_key   209.461k i/100ms
Calculating -------------------------------------
      Hash.keys.each      2.019M (± 0.3%) i/s -     10.279M in   5.092727s
       Hash.each_key      2.095M (± 0.0%) i/s -     10.683M in   5.099576s
                   with 95.0% confidence

Comparison:
       Hash.each_key:  2094785.3 i/s
      Hash.keys.each:  2018768.6 i/s - 1.04x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash key enumeration (size=20)

```
Warming up --------------------------------------
      Hash.keys.each   118.004k i/100ms
       Hash.each_key   118.320k i/100ms
Calculating -------------------------------------
      Hash.keys.each      1.176M (± 0.4%) i/s -      5.900M in   5.021554s
       Hash.each_key      1.182M (± 0.2%) i/s -      5.916M in   5.006809s
                   with 95.0% confidence

Comparison:
       Hash.each_key:  1181738.4 i/s
      Hash.keys.each:  1175522.6 i/s - same-ish: difference falls within error
                   with 95.0% confidence
```

#### Hash key enumeration (size=100)

```
Warming up --------------------------------------
      Hash.keys.each    27.217k i/100ms
       Hash.each_key    26.138k i/100ms
Calculating -------------------------------------
      Hash.keys.each    272.497k (± 0.0%) i/s -      1.388M in   5.093882s
       Hash.each_key    260.563k (± 0.4%) i/s -      1.307M in   5.017483s
                   with 95.0% confidence

Comparison:
      Hash.keys.each:   272497.2 i/s
       Hash.each_key:   260563.2 i/s - 1.05x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash key enumeration (size=500)

```
Warming up --------------------------------------
      Hash.keys.each     5.592k i/100ms
       Hash.each_key     5.404k i/100ms
Calculating -------------------------------------
      Hash.keys.each     55.763k (± 0.2%) i/s -    279.600k in   5.014897s
       Hash.each_key     54.060k (± 0.1%) i/s -    275.604k in   5.098253s
                   with 95.0% confidence

Comparison:
      Hash.keys.each:    55763.3 i/s
       Hash.each_key:    54060.3 i/s - 1.03x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=0)

```
Warming up --------------------------------------
    Hash.values.each   922.361k i/100ms
     Hash.each_value     1.372M i/100ms
Calculating -------------------------------------
    Hash.values.each      9.229M (± 0.0%) i/s -     47.040M in   5.096857s
     Hash.each_value     13.736M (± 0.0%) i/s -     69.983M in   5.094986s
                   with 95.0% confidence

Comparison:
     Hash.each_value: 13735592.7 i/s
    Hash.values.each:  9229287.5 i/s - 1.49x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=5)

```
Warming up --------------------------------------
    Hash.values.each   317.174k i/100ms
     Hash.each_value   358.507k i/100ms
Calculating -------------------------------------
    Hash.values.each      3.190M (± 0.0%) i/s -     16.176M in   5.071511s
     Hash.each_value      3.582M (± 0.0%) i/s -     17.925M in   5.004607s
                   with 95.0% confidence

Comparison:
     Hash.each_value:  3581759.4 i/s
    Hash.values.each:  3189555.5 i/s - 1.12x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=10)

```
Warming up --------------------------------------
    Hash.values.each   201.766k i/100ms
     Hash.each_value   209.128k i/100ms
Calculating -------------------------------------
    Hash.values.each      2.032M (± 0.0%) i/s -     10.290M in   5.065224s
     Hash.each_value      2.093M (± 0.0%) i/s -     10.666M in   5.096053s
                   with 95.0% confidence

Comparison:
     Hash.each_value:  2092905.3 i/s
    Hash.values.each:  2031517.4 i/s - 1.03x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=20)

```
Warming up --------------------------------------
    Hash.values.each   117.255k i/100ms
     Hash.each_value   117.577k i/100ms
Calculating -------------------------------------
    Hash.values.each      1.182M (± 0.1%) i/s -      5.980M in   5.058729s
     Hash.each_value      1.176M (± 0.0%) i/s -      5.996M in   5.098809s
                   with 95.0% confidence

Comparison:
    Hash.values.each:  1182126.7 i/s
     Hash.each_value:  1176047.5 i/s - 1.01x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=100)

```
Warming up --------------------------------------
    Hash.values.each    27.263k i/100ms
     Hash.each_value    26.208k i/100ms
Calculating -------------------------------------
    Hash.values.each    275.209k (± 0.0%) i/s -      1.390M in   5.052242s
     Hash.each_value    261.696k (± 0.0%) i/s -      1.310M in   5.007358s
                   with 95.0% confidence

Comparison:
    Hash.values.each:   275209.0 i/s
     Hash.each_value:   261696.2 i/s - 1.05x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=500)

```
Warming up --------------------------------------
    Hash.values.each     5.586k i/100ms
     Hash.each_value     5.408k i/100ms
Calculating -------------------------------------
    Hash.values.each     56.245k (± 0.2%) i/s -    284.886k in   5.066190s
     Hash.each_value     54.104k (± 0.0%) i/s -    275.808k in   5.097780s
                   with 95.0% confidence

Comparison:
    Hash.values.each:    56244.5 i/s
     Hash.each_value:    54104.0 i/s - 1.04x  (± 0.00) slower
                   with 95.0% confidence
```
