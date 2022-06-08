# frozen_string_literal: true

require 'kalibera'
require 'benchmark/ips'

# Enable and start GC before each job run. Disable GC afterwards.
#
# Inspired by https://www.omniref.com/ruby/2.2.1/symbols/Benchmark/bm?#annotation=4095926&line=182
class GCSuite
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  def warmup_stats(*)
  end

  def add_report(*)
  end

private

  def run_gc
    GC.enable
    GC.start
    GC.disable
  end
end

def as_boolean(val, default: nil)
  case val.to_s.strip.downcase
  when "true", "t", "yes", "y", "on", "1"
    true
  when "false", "f", "no", "n", "off", "0"
    false
  else
    raise "Unknown boolean value #{val}" if default.nil?

    default
  end
end

def section(title = nil)
  puts "\n#### #{title}" if title
  puts "\n```"
  GC.start
  Benchmark.ips do |bench|
    bench.config suite: GCSuite.new if GC_DISABLED
    bench.config stats: :bootstrap, confidence: 95

    yield bench
    bench.compare!
  end
  puts "```"
end

def display_benchmark_header
  puts
  puts "### Environment"
  puts
  puts RUBY_DESCRIPTION
  puts "GC Disabled: #{GC_DISABLED}"
  puts
  puts "### Test Cases"
end

GC_DISABLED = as_boolean(ENV.fetch('GC_DISABLED', nil), default: false)
