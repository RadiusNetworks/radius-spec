# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/hash_merge.rb
require_relative 'bm_setup'

display_benchmark_header

# rubocop:disable Style/HashTransformKeys
# Bad per Rubocop
def hash_transform_key_each_with_object(hash)
  hash.each_with_object({}) { |(k, v), h| h[k + 100] = v }
end

# Bad per Rubocop
def hash_transform_key_hash_collect(hash)
  Hash[hash.collect { |k, v| [k + 100, v] }]
end

# Bad per Rubocop
def hash_transform_key_map_to_h(hash)
  hash.map { |k, v| [k + 100, v] }.to_h
end

# Bad per Rubocop
def hash_transform_key_to_h_block(hash)
  hash.to_h { |k, v| [k + 100, v] }
end

# Good per Rubocop
def hash_transform_keys(hash)
  hash.transform_keys { |k| k + 100 }
end
# rubocop:enable Style/HashTransformKeys

[
  [],
  (1..5),
  (1..10),
  (1..20),
  (1..100),
  (1..500),
].each do |data|
  test_hash = data.zip(data).to_h

  section "Hash transform keys (size=#{data.size})" do |bench|
    bench.report("each_with_object") do
      hash_transform_key_each_with_object(test_hash)
    end

    bench.report("collect.Hash") do
      hash_transform_key_hash_collect(test_hash)
    end

    bench.report("map.to_h") do
      hash_transform_key_map_to_h(test_hash)
    end

    bench.report("to_h block") do
      hash_transform_key_to_h_block(test_hash)
    end

    bench.report("transform_keys") do
      hash_transform_keys(test_hash)
    end
  end
end

# rubocop:disable Style/HashTransformValues
# Bad per Rubocop
def hash_transform_value_each_with_object(hash)
  hash.each_with_object({}) { |(k, v), h| h[k] = v + 100 }
end

# Bad per Rubocop
def hash_transform_value_hash_collect(hash)
  Hash[hash.collect { |k, v| [k, v + 100] }]
end

# Bad per Rubocop
def hash_transform_value_map_to_h(hash)
  hash.map { |k, v| [k, v + 100] }.to_h
end

# Bad per Rubocop
def hash_transform_value_to_h_block(hash)
  hash.to_h { |k, v| [k, v + 100] }
end

# Good per Rubocop
def hash_transform_values(hash)
  hash.transform_values { |v| v + 100 }
end
# rubocop:enable Style/HashTransformValues

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
    bench.report("each_with_object") do
      hash_transform_value_each_with_object(test_hash)
    end

    bench.report("collect.Hash") do
      hash_transform_value_hash_collect(test_hash)
    end

    bench.report("map.to_h") do
      hash_transform_value_map_to_h(test_hash)
    end

    bench.report("to_h block") do
      hash_transform_value_to_h_block(test_hash)
    end

    bench.report("transform_values") do
      hash_transform_values(test_hash)
    end
  end
end

__END__

### Environment

Heroku Performance-L Dyno

ruby 2.7.3p183 (2021-04-05 revision 6847ee089d) [x86_64-linux]
GC Disabled: false

### Test Cases

These benchmarks confirm that regardless of the size of the hash, the
`transform_xyz` variants are much faster than the alternatives. It's
interesting to note that the performance difference for some of the variants
decreases as the hash size increases. However, even with the largest hash the
`transform_xyz` version is significantly faster.

#### Hash transform keys (size=0)

```
Warming up --------------------------------------
    each_with_object   538.673k i/100ms
        collect.Hash   342.897k i/100ms
            map.to_h   426.927k i/100ms
          to_h block     1.043M i/100ms
      transform_keys     1.083M i/100ms
Calculating -------------------------------------
    each_with_object      5.396M (± 0.0%) i/s -     27.472M in   5.091587s
        collect.Hash      3.434M (± 0.0%) i/s -     17.488M in   5.093257s
            map.to_h      4.263M (± 0.0%) i/s -     21.346M in   5.007195s
          to_h block     10.431M (± 0.0%) i/s -     52.164M in   5.000982s
      transform_keys     10.821M (± 0.0%) i/s -     54.133M in   5.002821s
                   with 95.0% confidence

Comparison:
      transform_keys: 10820597.2 i/s
          to_h block: 10430816.6 i/s - 1.04x  (± 0.00) slower
    each_with_object:  5395639.2 i/s - 2.01x  (± 0.00) slower
            map.to_h:  4263178.7 i/s - 2.54x  (± 0.00) slower
        collect.Hash:  3433510.5 i/s - 3.15x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash transform keys (size=5)

```
Warming up --------------------------------------
    each_with_object   101.033k i/100ms
        collect.Hash    91.559k i/100ms
            map.to_h    97.138k i/100ms
          to_h block   144.964k i/100ms
      transform_keys   236.915k i/100ms
Calculating -------------------------------------
    each_with_object      1.009M (± 0.0%) i/s -      5.052M in   5.008941s
        collect.Hash    914.359k (± 0.2%) i/s -      4.578M in   5.007666s
            map.to_h    968.789k (± 0.0%) i/s -      4.857M in   5.013387s
          to_h block      1.452M (± 0.0%) i/s -      7.393M in   5.091421s
      transform_keys      2.371M (± 0.1%) i/s -     12.083M in   5.096820s
                   with 95.0% confidence

Comparison:
      transform_keys:  2370806.9 i/s
          to_h block:  1452082.9 i/s - 1.63x  (± 0.00) slower
    each_with_object:  1008530.1 i/s - 2.35x  (± 0.00) slower
            map.to_h:   968788.7 i/s - 2.45x  (± 0.00) slower
        collect.Hash:   914358.6 i/s - 2.59x  (± 0.01) slower
                   with 95.0% confidence
```

#### Hash transform keys (size=10)

```
Warming up --------------------------------------
    each_with_object    48.415k i/100ms
        collect.Hash    49.273k i/100ms
            map.to_h    54.155k i/100ms
          to_h block    72.567k i/100ms
      transform_keys    99.649k i/100ms
Calculating -------------------------------------
    each_with_object    438.801k (± 0.2%) i/s -      2.227M in   5.075718s
        collect.Hash    493.563k (± 0.1%) i/s -      2.513M in   5.091711s
            map.to_h    550.742k (± 0.0%) i/s -      2.762M in   5.014922s
          to_h block    725.526k (± 0.0%) i/s -      3.628M in   5.001047s
      transform_keys    997.743k (± 0.4%) i/s -      5.082M in   5.094699s
                   with 95.0% confidence

Comparison:
      transform_keys:   997742.9 i/s
          to_h block:   725525.6 i/s - 1.38x  (± 0.00) slower
            map.to_h:   550741.9 i/s - 1.81x  (± 0.01) slower
        collect.Hash:   493562.5 i/s - 2.02x  (± 0.01) slower
    each_with_object:   438801.5 i/s - 2.27x  (± 0.01) slower
                   with 95.0% confidence
```

#### Hash transform keys (size=20)

```
Warming up --------------------------------------
    each_with_object    27.891k i/100ms
        collect.Hash    30.118k i/100ms
            map.to_h    31.586k i/100ms
          to_h block    41.472k i/100ms
      transform_keys    56.874k i/100ms
Calculating -------------------------------------
    each_with_object    259.309k (± 0.2%) i/s -      1.311M in   5.055247s
        collect.Hash    301.677k (± 0.0%) i/s -      1.536M in   5.091598s
            map.to_h    316.764k (± 0.0%) i/s -      1.611M in   5.085459s
          to_h block    416.878k (± 0.0%) i/s -      2.115M in   5.073771s
      transform_keys    566.454k (± 0.4%) i/s -      2.844M in   5.021314s
                   with 95.0% confidence

Comparison:
      transform_keys:   566453.6 i/s
          to_h block:   416877.9 i/s - 1.36x  (± 0.01) slower
            map.to_h:   316763.9 i/s - 1.79x  (± 0.01) slower
        collect.Hash:   301677.3 i/s - 1.88x  (± 0.01) slower
    each_with_object:   259308.7 i/s - 2.18x  (± 0.01) slower
                   with 95.0% confidence
```

#### Hash transform keys (size=100)

```
Warming up --------------------------------------
    each_with_object     6.252k i/100ms
        collect.Hash     6.684k i/100ms
            map.to_h     7.193k i/100ms
          to_h block     9.181k i/100ms
      transform_keys    12.110k i/100ms
Calculating -------------------------------------
    each_with_object     62.523k (± 0.0%) i/s -    318.852k in   5.099821s
        collect.Hash     66.729k (± 0.0%) i/s -    334.200k in   5.008308s
            map.to_h     71.711k (± 0.0%) i/s -    359.650k in   5.015342s
          to_h block     91.347k (± 0.0%) i/s -    459.050k in   5.025450s
      transform_keys    122.210k (± 0.1%) i/s -    617.610k in   5.053842s
                   with 95.0% confidence

Comparison:
      transform_keys:   122210.0 i/s
          to_h block:    91347.2 i/s - 1.34x  (± 0.00) slower
            map.to_h:    71710.5 i/s - 1.70x  (± 0.00) slower
        collect.Hash:    66729.5 i/s - 1.83x  (± 0.00) slower
    each_with_object:    62522.6 i/s - 1.95x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash transform keys (size=500)

```
Warming up --------------------------------------
    each_with_object     1.309k i/100ms
        collect.Hash     1.397k i/100ms
            map.to_h     1.501k i/100ms
          to_h block     1.881k i/100ms
      transform_keys     2.564k i/100ms
Calculating -------------------------------------
    each_with_object     13.113k (± 0.1%) i/s -     66.759k in   5.090832s
        collect.Hash     13.971k (± 0.1%) i/s -     69.850k in   5.000147s
            map.to_h     14.983k (± 0.0%) i/s -     75.050k in   5.009121s
          to_h block     18.827k (± 0.0%) i/s -     95.931k in   5.095314s
      transform_keys     26.712k (± 0.8%) i/s -    135.892k in   5.092990s
                   with 95.0% confidence

Comparison:
      transform_keys:    26711.7 i/s
          to_h block:    18827.4 i/s - 1.42x  (± 0.01) slower
            map.to_h:    14982.9 i/s - 1.78x  (± 0.01) slower
        collect.Hash:    13970.7 i/s - 1.91x  (± 0.02) slower
    each_with_object:    13113.5 i/s - 2.04x  (± 0.02) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=0)

```
Warming up --------------------------------------
    each_with_object   536.283k i/100ms
        collect.Hash   343.935k i/100ms
            map.to_h   412.861k i/100ms
          to_h block     1.006M i/100ms
    transform_values     1.034M i/100ms
Calculating -------------------------------------
    each_with_object      5.354M (± 0.3%) i/s -     26.814M in   5.009608s
        collect.Hash      3.438M (± 0.0%) i/s -     17.197M in   5.001856s
            map.to_h      4.129M (± 0.0%) i/s -     20.643M in   4.999982s
          to_h block      9.850M (± 0.0%) i/s -     49.315M in   5.006595s
    transform_values     10.253M (± 0.0%) i/s -     51.721M in   5.044573s
                   with 95.0% confidence

Comparison:
    transform_values: 10252746.8 i/s
          to_h block:  9850031.5 i/s - 1.04x  (± 0.00) slower
    each_with_object:  5353850.7 i/s - 1.92x  (± 0.01) slower
            map.to_h:  4128725.3 i/s - 2.48x  (± 0.00) slower
        collect.Hash:  3438102.9 i/s - 2.98x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=5)

```
Warming up --------------------------------------
    each_with_object   101.174k i/100ms
        collect.Hash    91.846k i/100ms
            map.to_h    96.742k i/100ms
          to_h block   144.714k i/100ms
    transform_values   334.829k i/100ms
Calculating -------------------------------------
    each_with_object      1.011M (± 0.0%) i/s -      5.059M in   5.002511s
        collect.Hash    916.962k (± 0.0%) i/s -      4.592M in   5.008221s
            map.to_h    969.007k (± 0.0%) i/s -      4.934M in   5.091657s
          to_h block      1.447M (± 0.0%) i/s -      7.236M in   5.000091s
    transform_values      3.356M (± 0.1%) i/s -     17.076M in   5.089207s
                   with 95.0% confidence

Comparison:
    transform_values:  3355662.6 i/s
          to_h block:  1447114.5 i/s - 2.32x  (± 0.00) slower
    each_with_object:  1011242.1 i/s - 3.32x  (± 0.00) slower
            map.to_h:   969007.2 i/s - 3.46x  (± 0.00) slower
        collect.Hash:   916962.3 i/s - 3.66x  (± 0.00) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=10)

```
Warming up --------------------------------------
    each_with_object    48.473k i/100ms
        collect.Hash    49.061k i/100ms
            map.to_h    53.340k i/100ms
          to_h block    72.241k i/100ms
    transform_values   146.939k i/100ms
Calculating -------------------------------------
    each_with_object    480.559k (± 0.1%) i/s -      2.424M in   5.043419s
        collect.Hash    492.989k (± 0.0%) i/s -      2.502M in   5.075419s
            map.to_h    546.714k (± 0.0%) i/s -      2.774M in   5.073369s
          to_h block    725.482k (± 0.0%) i/s -      3.684M in   5.078410s
    transform_values      1.575M (± 0.2%) i/s -      7.935M in   5.036956s
                   with 95.0% confidence

Comparison:
    transform_values:  1575397.1 i/s
          to_h block:   725482.0 i/s - 2.17x  (± 0.00) slower
            map.to_h:   546714.4 i/s - 2.88x  (± 0.00) slower
        collect.Hash:   492988.8 i/s - 3.20x  (± 0.01) slower
    each_with_object:   480559.2 i/s - 3.28x  (± 0.01) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=20)

```
Warming up --------------------------------------
    each_with_object    28.320k i/100ms
        collect.Hash    30.250k i/100ms
            map.to_h    31.925k i/100ms
          to_h block    42.127k i/100ms
    transform_values    87.393k i/100ms
Calculating -------------------------------------
    each_with_object    269.839k (± 0.2%) i/s -      1.359M in   5.037950s
        collect.Hash    303.464k (± 0.2%) i/s -      1.543M in   5.084567s
            map.to_h    318.494k (± 0.0%) i/s -      1.596M in   5.011840s
          to_h block    419.913k (± 0.0%) i/s -      2.106M in   5.016300s
    transform_values    801.802k (± 0.6%) i/s -      4.020M in   5.015563s
                   with 95.0% confidence

Comparison:
    transform_values:   801801.6 i/s
          to_h block:   419913.0 i/s - 1.91x  (± 0.01) slower
            map.to_h:   318494.2 i/s - 2.52x  (± 0.01) slower
        collect.Hash:   303464.4 i/s - 2.64x  (± 0.02) slower
    each_with_object:   269839.2 i/s - 2.97x  (± 0.02) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=100)

```
Warming up --------------------------------------
    each_with_object     6.319k i/100ms
        collect.Hash     6.686k i/100ms
            map.to_h     7.245k i/100ms
          to_h block     9.317k i/100ms
    transform_values    20.555k i/100ms
Calculating -------------------------------------
    each_with_object     63.102k (± 0.3%) i/s -    315.950k in   5.008225s
        collect.Hash     66.782k (± 0.0%) i/s -    334.300k in   5.005839s
            map.to_h     72.403k (± 0.0%) i/s -    362.250k in   5.003248s
          to_h block     93.020k (± 0.0%) i/s -    465.850k in   5.008075s
    transform_values    207.295k (± 0.1%) i/s -      1.048M in   5.057171s
                   with 95.0% confidence

Comparison:
    transform_values:   207294.9 i/s
          to_h block:    93020.0 i/s - 2.23x  (± 0.00) slower
            map.to_h:    72403.1 i/s - 2.86x  (± 0.00) slower
        collect.Hash:    66782.1 i/s - 3.10x  (± 0.00) slower
    each_with_object:    63102.3 i/s - 3.28x  (± 0.01) slower
                   with 95.0% confidence
```

#### Hash value enumeration (size=500)

```
Warming up --------------------------------------
    each_with_object     1.316k i/100ms
        collect.Hash     1.398k i/100ms
            map.to_h     1.496k i/100ms
          to_h block     1.876k i/100ms
    transform_values     4.471k i/100ms
Calculating -------------------------------------
    each_with_object     13.154k (± 0.1%) i/s -     65.800k in   5.002444s
        collect.Hash     13.983k (± 0.0%) i/s -     71.298k in   5.099149s
            map.to_h     14.968k (± 0.0%) i/s -     76.296k in   5.097225s
          to_h block     18.745k (± 0.0%) i/s -     93.800k in   5.004043s
    transform_values     44.903k (± 0.7%) i/s -    228.021k in   5.082046s
                   with 95.0% confidence

Comparison:
    transform_values:    44903.5 i/s
          to_h block:    18744.9 i/s - 2.40x  (± 0.02) slower
            map.to_h:    14968.1 i/s - 3.00x  (± 0.02) slower
        collect.Hash:    13982.6 i/s - 3.21x  (± 0.02) slower
    each_with_object:    13153.9 i/s - 3.41x  (± 0.02) slower
                   with 95.0% confidence
```
