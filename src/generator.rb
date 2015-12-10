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

    Contract RespondTo[:__gen__], HashOf[Symbol, Any] => Proc
    ##
    # Takes any class or object that defines a __gen__ method describing how to
    # generate a value of a certain size (if applicable for the value type).
    # Can also pass on a hash with further options to that method.
    def initialize(generable, options = {})
      @size = STANDARD_SIZE
      define_singleton_method(:generate) do |rng = Random.new|
        generable.__gen__(@size, options).call(rng)
      end
    end

    Contract Random => Enumerator
    ##
    # :call-seq:
    #   each(rng) -> Enumerator
    #   each(rng) {block}
    #   each(rng, size) -> Enumerator
    #   each(rng, size) {block}
    #
    # Yields the values generated to the provided _block_.
    # If no _size_ is specified an unlimited number of values will be yielded.
    # If no _block_ is specified an enumerator will be returned.
    def each(rng = Random.new)
      enum_for(:each, rng)
    end

    Contract Random, Proc => Any
    def each(rng = Random.new)
      loop { yield generate(rng) }
    end

    Contract Random, Nat => Enumerator
    def each(rng = Random.new, size)
      enum_for(:each, rng, size)
    end

    Contract Random, Nat, Proc => Any
    def each(rng = Random.new, size)
      size.times { yield generate(rng) }
    end

    Contract Integer => Generator
    ##
    # Returns a generator that will create different values even when using the
    # exact same Random number generator.
    def variant(perturb_factor)
      result = clone
      old_method = method(:generate)
      result.define_singleton_method(:generate) do |rng|
        perturb_factor.times { rng.rand }
        old_method.call(rng)
      end

      result
    end

    protected

    attr_accessor :size
  end
end
