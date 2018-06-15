# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/hash_merge.rb
require_relative 'bm_setup'

display_benchmark_header

ENUM = (1..100)

def hash_merge
  tmp = {}
  ENUM.each do |e|
    tmp.merge! e => e
  end
  tmp
end

def hash_assign
  tmp = {}
  ENUM.each do |e|
    tmp[e] = e
  end
  tmp
end

COMPOSE = {
  a: 'a',
  b: 'b',
  c: 'c',
}.freeze

def hash_compose_merge
  { one: 1 }.merge(COMPOSE)
end

def hash_compose_merge!
  { one: 1 }.merge!(COMPOSE)
end

def hash_compose_splat
  { one: 1, **COMPOSE }
end

section "Hash merge vs assign" do |bench|
  bench.report("Hash#merge!") do
    hash_merge
  end

  bench.report("Hash#[]=") do
    hash_assign
  end
end

section "Hash compose: merge vs splat" do |bench|
  bench.report("merge") do
    hash_compose_merge
  end

  bench.report("merge!") do
    hash_compose_merge!
  end

  bench.report("splat") do
    hash_compose_splat
  end
end

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Hash merge vs assign

```
Warming up --------------------------------------
         Hash#merge!     1.760k i/100ms
            Hash#[]=     7.821k i/100ms
Calculating -------------------------------------
         Hash#merge!     17.746k (± 1.1%) i/s -     89.760k in   5.065762s
            Hash#[]=     83.691k (± 1.2%) i/s -    422.334k in   5.057697s
                   with 95.0% confidence

Comparison:
            Hash#[]=:    83691.2 i/s
         Hash#merge!:    17746.3 i/s - 4.71x  (± 0.08) slower
                   with 95.0% confidence
```

#### Hash compose: merge vs splat

```
Warming up --------------------------------------
               merge    78.448k i/100ms
              merge!   111.435k i/100ms
               splat   111.927k i/100ms
Calculating -------------------------------------
               merge    978.337k (± 1.0%) i/s -      4.942M in   5.061428s
              merge!      1.571M (± 1.0%) i/s -      7.912M in   5.046875s
               splat      1.587M (± 1.0%) i/s -      7.947M in   5.017037s
                   with 95.0% confidence

Comparison:
               splat:  1587073.4 i/s
              merge!:  1570636.9 i/s - same-ish: difference falls within error
               merge:   978337.3 i/s - 1.62x  (± 0.02) slower
                   with 95.0% confidence
```
