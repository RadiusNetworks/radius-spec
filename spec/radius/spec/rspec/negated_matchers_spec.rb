# frozen_string_literal: true

RSpec.describe "Custom negated matchers" do
  specify "`exclude` is the inverse of `include`" do
    x = [1, 2]

    expect(x).to exclude(3)
    expect {
      expect(x).not_to exclude(3)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)

    expect(x).not_to exclude(1)
    expect {
      expect(x).to exclude(1)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  specify "`excluding` is the inverse of `including`" do
    x = [1, 2]

    expect(x).to excluding(3)
    expect {
      expect(x).not_to excluding(3)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)

    expect(x).not_to excluding(1)
    expect {
      expect(x).to excluding(1)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  specify "`not_eq` is the inverse of `eq`" do
    x = :any_value

    expect(x).to not_eq(:diff_value)
    expect {
      expect(x).not_to not_eq(:diff_value)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)

    expect(x).not_to not_eq(:any_value)
    expect {
      expect(x).to not_eq(:any_value)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  specify "`not_change` is the inverse of `change`" do
    x = []
    expect {
      x.to_s
    }.to not_change {
      x
    }.from([])

    expect {
      expect {
        x << :anything
      }.to not_change {
        x
      }
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  specify "`not_raise_error` is the inverse of `raise_error`" do
    expect { :noop }.to not_raise_error

    expect {
      expect { raise "Any Error" }.to not_raise_error
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  specify "`not_raise_exception` is the inverse of `raise_exception`" do
    expect { :noop }.to not_raise_exception

    expect {
      expect { raise "Any Error" }.to not_raise_exception
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end
end
