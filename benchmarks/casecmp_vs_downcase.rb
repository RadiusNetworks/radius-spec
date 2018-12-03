# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/casecmp_vs_downcase.rb
require_relative 'bm_setup'

display_benchmark_header

EXPECTED = "match"

puts "### Base Cases"

def downcase_eql(test_case)
  EXPECTED == test_case.downcase
end

def casecmp_eql(test_case)
  0 == EXPECTED.casecmp(test_case)
end

def casecmp_zero(test_case)
  EXPECTED.casecmp(test_case).zero?
end

# This is similar to the original Rubocop cited benchmark code.
["No MaTcH", "MaTcH"].each do |test_case|
  section "Case: #{test_case.downcase}" do |bench|
    bench.report("== downcase") do
      downcase_eql(test_case)
    end

    bench.report("== casecmp") do
      casecmp_eql(test_case)
    end

    bench.report("casecmp.zero?") do
      casecmp_zero(test_case)
    end
  end
end

# As of Ruby 2.5 both `casecmp` and `casecmp?` accept any object. In the cases
# where the object is not a string they return `nil`. Prior Ruby 2.5 string
# conversions need to occur before the compare.
puts "### Type Cases"

def tos_downcase_eql(test_case)
  EXPECTED == test_case.to_s.downcase
end

def safe_casecmp_zero(test_case)
  EXPECTED.casecmp(test_case)&.zero?
end

def casecmp_to_i_zero(test_case)
  EXPECTED.casecmp(test_case).to_i.zero?
end

def casecmp?(test_case)
  EXPECTED.casecmp?(test_case)
end

class StringLike
  def initialize(test_case)
    @test_case = test_case
  end

  def to_str
    @test_case
  end
end

[
  nil,
  "no match",
  "match",
  123,
  Object.new,
  StringLike.new("no match"),
  StringLike.new("match"),
].each do |test_case|
  section "Type Case: #{test_case.inspect}" do |bench|
    bench.report("== to_s.downcase") do
      tos_downcase_eql(test_case)
    end

    bench.report("== casecmp") do
      casecmp_eql(test_case)
    end

    bench.report("casecmp.zero?") do
      safe_casecmp_zero(test_case)
    end

    bench.report("casecmp.to_i.zero?") do
      casecmp_to_i_zero(test_case)
    end

    bench.report("casecmp?") do
      casecmp?(test_case)
    end
  end
end

def pre_casecmp_eql(test_case)
  test_case && 0 == EXPECTED.casecmp(test_case)
end

def pre_casecmp_zero(test_case)
  test_case && EXPECTED.casecmp(test_case).zero?
end

def pre_bang_casecmp_eql(test_case)
  !!test_case && 0 == EXPECTED.casecmp(test_case)
end

def pre_bang_casecmp_zero(test_case)
  !!test_case && EXPECTED.casecmp(test_case).zero?
end

def pre_nil_casecmp_eql(test_case)
  !test_case.nil? && 0 == EXPECTED.casecmp(test_case)
end

def pre_nil_casecmp_zero(test_case)
  !test_case.nil? && EXPECTED.casecmp(test_case).zero?
end

# Given the results below this is another set of tests to try to determine if
# knowing you'll either have `nil` or a `String`
[nil, "no match"].each do |test_case|
  section "Pre-check Case: #{test_case.inspect}" do |bench|
    bench.report("== casecmp(to_s)") do
      casecmp_eql(test_case.to_s)
    end

    if RUBY_VERSION.to_f > 2.3
      bench.report("casecmp?(to_s)") do
        casecmp?(test_case.to_s)
      end
    end

    if RUBY_VERSION.to_f > 2.4
      bench.report("casecmp?") do
        casecmp?(test_case)
      end
    end

    bench.report("falsey casecmp.zero?") do
      pre_casecmp_zero(test_case)
    end

    bench.report("falsey == casecmp") do
      pre_casecmp_eql(test_case)
    end

    bench.report("!! casecmp.zero?") do
      pre_bang_casecmp_zero(test_case)
    end

    bench.report("!! == casecmp") do
      pre_bang_casecmp_eql(test_case)
    end

    bench.report("nil? casecmp.zero?") do
      pre_nil_casecmp_zero(test_case)
    end

    bench.report("nil? == casecmp") do
      pre_nil_casecmp_eql(test_case)
    end
  end
end

__END__

These results were a little surprising. With `casecmp?` being implemented in C
I fully expected that to be the fastest version. As the results below show, it
was actually the slowest except for the `nil` case. Given both `casecmp` and
`casecmp?` need to perform the same type coercions in Ruby 2.5 this is still
a bit of a mystery to me.

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

### Base Cases

#### Case: no match

```
Warming up --------------------------------------
         == downcase   212.956k i/100ms
          == casecmp   242.441k i/100ms
       casecmp.zero?   250.362k i/100ms
Calculating -------------------------------------
         == downcase      5.758M (± 1.1%) i/s -     28.749M in   5.013717s
          == casecmp      7.263M (± 0.8%) i/s -     36.366M in   5.018952s
       casecmp.zero?      6.641M (± 0.9%) i/s -     33.298M in   5.026902s
                   with 95.0% confidence

Comparison:
          == casecmp:  7262964.1 i/s
       casecmp.zero?:  6640838.5 i/s - 1.09x  (± 0.01) slower
         == downcase:  5757879.1 i/s - 1.26x  (± 0.02) slower
                   with 95.0% confidence
```

#### Case: match

```
Warming up --------------------------------------
         == downcase   223.277k i/100ms
          == casecmp   255.309k i/100ms
       casecmp.zero?   244.326k i/100ms
Calculating -------------------------------------
         == downcase      5.601M (± 0.7%) i/s -     28.133M in   5.031201s
          == casecmp      7.069M (± 0.9%) i/s -     35.488M in   5.033449s
       casecmp.zero?      6.514M (± 1.0%) i/s -     32.495M in   5.007338s
                   with 95.0% confidence

Comparison:
          == casecmp:  7069433.4 i/s
       casecmp.zero?:  6513865.5 i/s - 1.09x  (± 0.01) slower
         == downcase:  5600607.7 i/s - 1.26x  (± 0.01) slower
                   with 95.0% confidence
```
### Type Cases

#### Type Case: nil

```
Warming up --------------------------------------
    == to_s.downcase   206.757k i/100ms
          == casecmp   165.652k i/100ms
       casecmp.zero?   243.968k i/100ms
  casecmp.to_i.zero?   228.771k i/100ms
            casecmp?   245.631k i/100ms
Calculating -------------------------------------
    == to_s.downcase      4.457M (± 1.3%) i/s -     22.330M in   5.036046s
          == casecmp      2.959M (± 0.9%) i/s -     14.909M in   5.048155s
       casecmp.zero?      6.571M (± 0.8%) i/s -     32.936M in   5.023643s
  casecmp.to_i.zero?      5.610M (± 1.0%) i/s -     28.139M in   5.030920s
            casecmp?      6.426M (± 0.9%) i/s -     32.178M in   5.022549s
                   with 95.0% confidence

Comparison:
       casecmp.zero?:  6570981.1 i/s
            casecmp?:  6426432.5 i/s - 1.02x  (± 0.01) slower
  casecmp.to_i.zero?:  5609983.7 i/s - 1.17x  (± 0.02) slower
    == to_s.downcase:  4457210.7 i/s - 1.47x  (± 0.02) slower
          == casecmp:  2959310.9 i/s - 2.22x  (± 0.03) slower
                   with 95.0% confidence
```

#### Type Case: "no match"

```
Warming up --------------------------------------
    == to_s.downcase   224.166k i/100ms
          == casecmp   255.225k i/100ms
       casecmp.zero?   244.858k i/100ms
  casecmp.to_i.zero?   239.323k i/100ms
            casecmp?   184.603k i/100ms
Calculating -------------------------------------
    == to_s.downcase      4.986M (± 1.7%) i/s -     24.882M in   5.041514s
          == casecmp      7.478M (± 0.9%) i/s -     37.518M in   5.033271s
       casecmp.zero?      6.879M (± 1.0%) i/s -     34.525M in   5.036217s
  casecmp.to_i.zero?      6.166M (± 0.9%) i/s -     30.873M in   5.021792s
            casecmp?      4.520M (± 1.5%) i/s -     22.522M in   5.022920s
                   with 95.0% confidence

Comparison:
          == casecmp:  7478045.4 i/s
       casecmp.zero?:  6878660.6 i/s - 1.09x  (± 0.01) slower
  casecmp.to_i.zero?:  6166061.6 i/s - 1.21x  (± 0.02) slower
    == to_s.downcase:  4985671.0 i/s - 1.50x  (± 0.03) slower
            casecmp?:  4520190.0 i/s - 1.65x  (± 0.03) slower
                   with 95.0% confidence
```

#### Type Case: "match"

```
Warming up --------------------------------------
    == to_s.downcase   222.165k i/100ms
          == casecmp   255.637k i/100ms
       casecmp.zero?   242.725k i/100ms
  casecmp.to_i.zero?   234.070k i/100ms
            casecmp?   196.526k i/100ms
Calculating -------------------------------------
    == to_s.downcase      5.061M (± 1.1%) i/s -     25.327M in   5.022350s
          == casecmp      7.213M (± 0.8%) i/s -     36.045M in   5.009733s
       casecmp.zero?      6.591M (± 0.9%) i/s -     33.011M in   5.021453s
  casecmp.to_i.zero?      5.916M (± 0.9%) i/s -     29.727M in   5.039360s
            casecmp?      4.462M (± 1.2%) i/s -     22.404M in   5.041505s
                   with 95.0% confidence

Comparison:
          == casecmp:  7212692.8 i/s
       casecmp.zero?:  6590791.5 i/s - 1.09x  (± 0.01) slower
  casecmp.to_i.zero?:  5915576.8 i/s - 1.22x  (± 0.02) slower
    == to_s.downcase:  5060645.9 i/s - 1.43x  (± 0.02) slower
            casecmp?:  4462174.0 i/s - 1.62x  (± 0.02) slower
                   with 95.0% confidence
```

#### Type Case: 123

```
Warming up --------------------------------------
    == to_s.downcase   194.578k i/100ms
          == casecmp   162.422k i/100ms
       casecmp.zero?   241.653k i/100ms
  casecmp.to_i.zero?   225.119k i/100ms
            casecmp?   240.602k i/100ms
Calculating -------------------------------------
    == to_s.downcase      4.099M (± 1.0%) i/s -     20.625M in   5.045741s
          == casecmp      3.068M (± 1.1%) i/s -     15.430M in   5.044417s
       casecmp.zero?      6.334M (± 0.8%) i/s -     31.657M in   5.007791s
  casecmp.to_i.zero?      5.284M (± 1.6%) i/s -     26.339M in   5.031971s
            casecmp?      6.478M (± 1.0%) i/s -     32.481M in   5.031290s
                   with 95.0% confidence

Comparison:
            casecmp?:  6478253.4 i/s
       casecmp.zero?:  6333577.2 i/s - 1.02x  (± 0.01) slower
  casecmp.to_i.zero?:  5284198.7 i/s - 1.23x  (± 0.02) slower
    == to_s.downcase:  4098628.0 i/s - 1.58x  (± 0.02) slower
          == casecmp:  3067817.5 i/s - 2.11x  (± 0.03) slower
                   with 95.0% confidence
```

#### Type Case: #<Object:0x00007fcd219587b0>

```
Warming up --------------------------------------
    == to_s.downcase    52.158k i/100ms
          == casecmp   163.492k i/100ms
       casecmp.zero?   240.188k i/100ms
  casecmp.to_i.zero?   226.153k i/100ms
            casecmp?   236.788k i/100ms
Calculating -------------------------------------
    == to_s.downcase    640.939k (± 1.1%) i/s -      3.234M in   5.053840s
          == casecmp      3.075M (± 0.9%) i/s -     15.368M in   5.008669s
       casecmp.zero?      6.623M (± 0.9%) i/s -     33.146M in   5.020333s
  casecmp.to_i.zero?      5.376M (± 1.2%) i/s -     26.912M in   5.027477s
            casecmp?      6.726M (± 1.0%) i/s -     33.624M in   5.016239s
                   with 95.0% confidence

Comparison:
            casecmp?:  6726445.6 i/s
       casecmp.zero?:  6623328.3 i/s - same-ish: difference falls within error
  casecmp.to_i.zero?:  5376386.8 i/s - 1.25x  (± 0.02) slower
          == casecmp:  3074731.3 i/s - 2.19x  (± 0.03) slower
    == to_s.downcase:   640938.7 i/s - 10.49x  (± 0.15) slower
                   with 95.0% confidence
```

#### Type Case: #<StringLike:0x00007fcd21958788 @test_case="no match">

```
Warming up --------------------------------------
    == to_s.downcase    52.238k i/100ms
          == casecmp   212.362k i/100ms
       casecmp.zero?   207.266k i/100ms
  casecmp.to_i.zero?   203.147k i/100ms
            casecmp?   179.658k i/100ms
Calculating -------------------------------------
    == to_s.downcase    649.352k (± 0.9%) i/s -      3.291M in   5.074729s
          == casecmp      5.069M (± 0.9%) i/s -     25.483M in   5.039082s
       casecmp.zero?      4.852M (± 0.9%) i/s -     24.250M in   5.011911s
  casecmp.to_i.zero?      4.395M (± 1.1%) i/s -     21.940M in   5.009899s
            casecmp?      3.443M (± 1.3%) i/s -     17.247M in   5.028774s
                   with 95.0% confidence

Comparison:
          == casecmp:  5068628.3 i/s
       casecmp.zero?:  4851650.8 i/s - 1.04x  (± 0.01) slower
  casecmp.to_i.zero?:  4394669.1 i/s - 1.15x  (± 0.02) slower
            casecmp?:  3443238.5 i/s - 1.47x  (± 0.02) slower
    == to_s.downcase:   649351.6 i/s - 7.81x  (± 0.10) slower
                   with 95.0% confidence
```

#### Type Case: #<StringLike:0x00007fcd21958760 @test_case="match">

```
Warming up --------------------------------------
    == to_s.downcase    53.698k i/100ms
          == casecmp   211.054k i/100ms
       casecmp.zero?   209.614k i/100ms
  casecmp.to_i.zero?   205.111k i/100ms
            casecmp?   177.677k i/100ms
Calculating -------------------------------------
    == to_s.downcase    642.352k (± 1.1%) i/s -      3.222M in   5.024341s
          == casecmp      4.801M (± 0.9%) i/s -     24.060M in   5.023696s
       casecmp.zero?      4.509M (± 0.9%) i/s -     22.638M in   5.032909s
  casecmp.to_i.zero?      4.450M (± 1.2%) i/s -     22.357M in   5.044182s
            casecmp?      3.332M (± 1.1%) i/s -     16.702M in   5.028767s
                   with 95.0% confidence

Comparison:
          == casecmp:  4801157.9 i/s
       casecmp.zero?:  4508944.8 i/s - 1.06x  (± 0.01) slower
  casecmp.to_i.zero?:  4449914.9 i/s - 1.08x  (± 0.02) slower
            casecmp?:  3332042.5 i/s - 1.44x  (± 0.02) slower
    == to_s.downcase:   642351.9 i/s - 7.47x  (± 0.11) slower
                   with 95.0% confidence
```

#### Pre-check Case: nil

```
Warming up --------------------------------------
    == casecmp(to_s)   222.939k i/100ms
      casecmp?(to_s)   188.102k i/100ms
            casecmp?   236.868k i/100ms
falsey casecmp.zero?   279.966k i/100ms
   falsey == casecmp   282.745k i/100ms
    !! casecmp.zero?   266.091k i/100ms
       !! == casecmp   266.932k i/100ms
  nil? casecmp.zero?   272.193k i/100ms
     nil? == casecmp   273.029k i/100ms
Calculating -------------------------------------
    == casecmp(to_s)      4.937M (± 1.0%) i/s -     24.746M in   5.024918s
      casecmp?(to_s)      3.589M (± 1.1%) i/s -     18.058M in   5.046262s
            casecmp?      6.417M (± 1.2%) i/s -     31.977M in   5.007501s
falsey casecmp.zero?      9.773M (± 1.0%) i/s -     48.714M in   5.008779s
   falsey == casecmp     10.045M (± 0.9%) i/s -     50.046M in   5.001595s
    !! casecmp.zero?      9.330M (± 0.9%) i/s -     46.566M in   5.009468s
       !! == casecmp      8.754M (± 2.1%) i/s -     42.442M in   5.001546s
  nil? casecmp.zero?      8.716M (± 1.0%) i/s -     43.551M in   5.017106s
     nil? == casecmp      8.596M (± 0.8%) i/s -     42.866M in   5.000683s
                   with 95.0% confidence

Comparison:
   falsey == casecmp: 10045375.1 i/s
falsey casecmp.zero?:  9772608.7 i/s - 1.03x  (± 0.01) slower
    !! casecmp.zero?:  9330161.0 i/s - 1.08x  (± 0.01) slower
       !! == casecmp:  8754421.4 i/s - 1.15x  (± 0.03) slower
  nil? casecmp.zero?:  8715727.1 i/s - 1.15x  (± 0.02) slower
     nil? == casecmp:  8595661.2 i/s - 1.17x  (± 0.01) slower
            casecmp?:  6417121.6 i/s - 1.57x  (± 0.02) slower
    == casecmp(to_s):  4936724.1 i/s - 2.03x  (± 0.03) slower
      casecmp?(to_s):  3588687.7 i/s - 2.80x  (± 0.04) slower
                   with 95.0% confidence
```

#### Pre-check Case: "no match"

```
Warming up --------------------------------------
    == casecmp(to_s)   245.036k i/100ms
      casecmp?(to_s)   196.918k i/100ms
            casecmp?   208.835k i/100ms
falsey casecmp.zero?   252.889k i/100ms
   falsey == casecmp   253.206k i/100ms
    !! casecmp.zero?   237.682k i/100ms
       !! == casecmp   237.849k i/100ms
  nil? casecmp.zero?   235.435k i/100ms
     nil? == casecmp   242.031k i/100ms
Calculating -------------------------------------
    == casecmp(to_s)      6.598M (± 1.0%) i/s -     33.080M in   5.031444s
      casecmp?(to_s)      4.044M (± 1.2%) i/s -     20.283M in   5.036826s
            casecmp?      4.503M (± 0.9%) i/s -     22.554M in   5.019573s
falsey casecmp.zero?      6.692M (± 0.8%) i/s -     33.634M in   5.036615s
   falsey == casecmp      7.031M (± 0.9%) i/s -     35.196M in   5.018913s
    !! casecmp.zero?      6.074M (± 1.1%) i/s -     30.423M in   5.029842s
       !! == casecmp      6.146M (± 0.8%) i/s -     30.683M in   5.001632s
  nil? casecmp.zero?      5.891M (± 0.8%) i/s -     29.429M in   5.006134s
     nil? == casecmp      6.238M (± 0.8%) i/s -     31.222M in   5.015890s
                   with 95.0% confidence

Comparison:
   falsey == casecmp:  7031044.2 i/s
falsey casecmp.zero?:  6691656.4 i/s - 1.05x  (± 0.01) slower
    == casecmp(to_s):  6598167.5 i/s - 1.07x  (± 0.01) slower
     nil? == casecmp:  6237735.7 i/s - 1.13x  (± 0.01) slower
       !! == casecmp:  6146232.8 i/s - 1.14x  (± 0.01) slower
    !! casecmp.zero?:  6073969.3 i/s - 1.16x  (± 0.02) slower
  nil? casecmp.zero?:  5890972.7 i/s - 1.19x  (± 0.01) slower
            casecmp?:  4503136.8 i/s - 1.56x  (± 0.02) slower
      casecmp?(to_s):  4043637.6 i/s - 1.74x  (± 0.03) slower
                   with 95.0% confidence
```
