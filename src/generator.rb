# Encoding: utf-8
require "contracts"
require_relative "generator/builtin_generables"

##
# Basic RubyQuickCheck module.
module RubyQuickCheck
  include Contracts

  ##
  # =Random value generators.
  #
  # The most basic method defined is #generate which takes a Random number
  # generator and returns a random value as defined by the generator.
  class Generator
    include Contracts

    STANDARD_SIZE = 30

    ##
    # Takes any class or object that defines a __gen__ method describing how to
    # generate a value of a certain size (if applicable for the value type).
    # Can also pass on a hash with further options to that method.
    Contract RespondTo[:__gen__], HashOf[Symbol, Any] => Proc
    def initialize(generable, options = {})
      @size = STANDARD_SIZE
      define_singleton_method(:generate) do |rng = Random.new|
        generable.__gen__(@size, options).call(rng)
      end
    end

    protected

    attr_accessor :size
  end
end
