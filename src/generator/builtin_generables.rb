# Encoding: utf-8
require "contracts"

# rubocop:disable Style/Documentation
class Array
  include Contracts

  ##
  # Produces a random element from the array.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Any]
  def __gen__(_size = 0, _options = {})
    fail ArgumentError, "generator from empty list" if length == 0

    proc { |rng| slice(rng.rand(0...length)) }
  end
end

class Range
  include Contracts

  ##
  # Produces a random value from the range.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Any]
  def __gen__(_size = 0, _options = {})
    if self.begin.is_a? String
      proc { |rng| rng.rand(self.begin.ord..self.end.ord).chr }
    else
      proc { |rng| rng.rand(self) }
    end
  end
end

##
# Representant module for the Boolean type since true and false are singletons
# of their own classes in Ruby.
module Boolean
  include Contracts

  ##
  # Produces either true or false.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Bool]
  def self.__gen__(_size = 0, _options = {})
    m = [true, false].__gen__

    proc { |rng| m.call(rng) }
  end
end

class TrueClass
  include Boolean
end

class FalseClass
  include Boolean
end

class Integer
  include Contracts

  FIXNUM_MAX = (2**(0.size * 8 - 2) - 1) / 2
  FIXNUM_MIN = -FIXNUM_MAX

  ##
  # Produces a random integer value between -size and size.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Integer]
  def self.__gen__(size, _options = {})
    m = (-size..size).__gen__
    proc { |rng| m.call(rng) }
  end
end

class Float
  include Contracts

  ##
  # Produces a random float value between -size and size.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Float]
  def self.__gen__(size, _options = {})
    m1 = Integer.__gen__(size - 1)
    m2 = Integer.__gen__(Fixnum::FIXNUM_MAX)

    proc { |rng| m1.call(rng) + m2.call(rng) * 1.0 / Fixnum::FIXNUM_MAX }
  end
end

class Complex
  include Contracts

  ##
  # Produces a random complex value with real and imaginary part respectively
  # between -size and size.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Complex]
  def self.__gen__(size, _options = {})
    m = Float.__gen__(size)

    proc { |rng| Complex(m.call(rng), m.call(rng)) }
  end
end

class Rational
  include Contracts

  ##
  # Produces a random rational value between -size and size.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Rational]
  def self.__gen__(size, _options = {})
    m1 = Integer.__gen__(size - 1)
    m2 = Integer.__gen__(size)

    proc { |rng| m1.call(rng) + Rational(m2.call(rng), size) }
  end
end

class Time
  include Contracts

  ##
  # Produces a random Time value with a UNIX timestamp between -size and size.
  Contract Nat, HashOf[Symbol, Any] => Func[Random => Time]
  def self.__gen__(size, _options = {})
    m = Integer.__gen__(size)

    proc { |rng| Time.at(m.call(rng)) }
  end
end
