# Encoding: utf-8
require "rspec"
require_relative "sharedexamples"
require_relative "../../src/generator"

#
module RubyQuickCheck
  BASIC_TYPES = [Boolean, Integer, Float, Complex, Rational, Time]

  BASIC_TYPES.each do |generable|

    describe "#{generable} generator", test_all_types: true do
      subject(:generator) { Generator.new(generable) }

      it_behaves_like "all generators"
    end
  end
end
