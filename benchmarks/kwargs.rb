# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/kwargs.rb
require_relative 'bm_setup'

display_benchmark_header

NAME = "any name"
STATIC_OPTS = { name: "any name" }.freeze

def hash_param(hash)
  hash
end

def kwarg_param(name: nil)
  name
end

def kwarg_splat_param(**kwargs)
  kwargs
end

def static_opts
  kwarg_param STATIC_OPTS
end

def named_opts
  kwarg_param name: NAME
end

def splat_opts
  kwarg_splat_param name: NAME
end

def hash_opts
  hash_param name: NAME
end

section "kwargs vs hash method" do |x|
  x.report("hash param") do
    hash_opts
  end

  x.report("kwarg param") do
    named_opts
  end

  x.report("kwarg splat param") do
    splat_opts
  end

  x.compare!
end

section "Call kwargs method" do |x|
  x.report("static opts") do
    static_opts
  end

  x.report("named opts") do
    named_opts
  end

  x.compare!
end

__END__

Perhaps surprisingly the kwarg parameters option is much faster. I'm not sure
why this actually is, but my guess is that Ruby optimizes this during the byte
code process.

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### kwargs vs hash method

```
Warming up --------------------------------------
          hash param   131.753k i/100ms
         kwarg param   266.657k i/100ms
   kwarg splat param    66.641k i/100ms
Calculating -------------------------------------
          hash param      2.057M (± 1.6%) i/s -     10.277M in   5.023252s
         kwarg param      7.351M (± 0.7%) i/s -     36.799M in   5.015356s
   kwarg splat param    850.179k (± 1.4%) i/s -      4.265M in   5.035194s
                   with 95.0% confidence

Comparison:
         kwarg param:  7351007.8 i/s
          hash param:  2056501.2 i/s - 3.57x  (± 0.06) slower
   kwarg splat param:   850179.4 i/s - 8.64x  (± 0.13) slower
                   with 95.0% confidence
```

#### Call kwargs method

```
Warming up --------------------------------------
         static opts   127.699k i/100ms
          named opts   274.978k i/100ms
Calculating -------------------------------------
         static opts      1.879M (± 1.0%) i/s -      9.450M in   5.039627s
          named opts      6.938M (± 1.1%) i/s -     34.647M in   5.014500s
                   with 95.0% confidence

Comparison:
          named opts:  6937888.3 i/s
         static opts:  1878705.6 i/s - 3.69x  (± 0.05) slower
                   with 95.0% confidence
```

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: true

### Test Cases

#### kwargs vs hash method

```
Warming up --------------------------------------
          hash param   144.722k i/100ms
         kwarg param   266.216k i/100ms
   kwarg splat param    67.212k i/100ms
Calculating -------------------------------------
          hash param      2.318M (± 5.2%) i/s -     10.709M in   5.017846s
         kwarg param      7.381M (± 0.8%) i/s -     37.004M in   5.026198s
   kwarg splat param    893.963k (±15.1%) i/s -      3.159M in   5.180853s
                   with 95.0% confidence

Comparison:
         kwarg param:  7380700.1 i/s
          hash param:  2317626.6 i/s - 3.19x  (± 0.17) slower
   kwarg splat param:   893963.2 i/s - 8.26x  (± 1.26) slower
                   with 95.0% confidence
```

#### Call kwargs method

```
Warming up --------------------------------------
         static opts   157.568k i/100ms
          named opts   271.741k i/100ms
Calculating -------------------------------------
         static opts      1.741M (±12.7%) i/s -      7.091M in   5.038616s
          named opts      7.335M (± 0.7%) i/s -     36.685M in   5.010800s
                   with 95.0% confidence

Comparison:
          named opts:  7335402.3 i/s
         static opts:  1740760.5 i/s - 4.21x  (± 0.53) slower
                   with 95.0% confidence
```
