# frozen_string_literal: true

# Run from the command line: bundle exec ruby benchmarks/unpack_first.rb
require_relative 'bm_setup'

display_benchmark_header

PACKED_STRING = "foo"
PACKED_FORMAT = "h*"

# rubocop:disable Style/UnpackFirst
section "Unpacking strings" do |bench|
  bench.report("unpack.first") do
    PACKED_STRING.unpack(PACKED_FORMAT).first
  end

  bench.report("unpack[0]") do
    PACKED_STRING.unpack(PACKED_FORMAT)[0]
  end

  bench.report("unpack1") do
    PACKED_STRING.unpack1(PACKED_FORMAT)
  end
end
# rubocop:enable Style/UnpackFirst

__END__

### Environment

ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
GC Disabled: false

### Test Cases

#### Unpacking strings

```
Warming up --------------------------------------
        unpack.first   228.848k i/100ms
           unpack[0]   225.375k i/100ms
             unpack1   254.431k i/100ms
Calculating -------------------------------------
        unpack.first      5.074M (± 1.0%) i/s -     25.402M in   5.021645s
           unpack[0]      5.412M (± 1.0%) i/s -     27.045M in   5.012499s
             unpack1      7.185M (± 0.9%) i/s -     35.875M in   5.011588s
                   with 95.0% confidence

Comparison:
             unpack1:  7184877.9 i/s
           unpack[0]:  5412005.1 i/s - 1.33x  (± 0.02) slower
        unpack.first:  5074389.3 i/s - 1.42x  (± 0.02) slower
                   with 95.0% confidence
```
