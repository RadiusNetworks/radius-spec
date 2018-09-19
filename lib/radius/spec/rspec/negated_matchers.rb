# frozen_string_literal: true

# Define negated matchers for use with composable matchers and compound
# expectations.
#
# @see https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/composing-matchers
# @see https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/compound-expectations
RSpec::Matchers.define_negated_matcher :exclude, :include
RSpec::Matchers.define_negated_matcher :excluding, :including
RSpec::Matchers.define_negated_matcher :not_eq, :eq

# Allows us to check that a block doesn't raise an exception while also
# checking for other changes using compound expectations; since you can't chain
# a negative (`not_to`) with any other matchers
#
# @see https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/compound-expectations
RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec::Matchers.define_negated_matcher :not_raise_error, :raise_error
RSpec::Matchers.define_negated_matcher :not_raise_exception, :raise_exception
