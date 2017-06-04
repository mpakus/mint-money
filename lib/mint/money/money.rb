# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require 'forwardable'
require_relative './currency'
require_relative './exceptions'
require_relative './utils'

module Mint
  # Money Management
  class Money
    include Comparable

    attr_reader :value, :currency, :currency_sym
    alias amount value

    def initialize(value = 0.00, currency = nil)
      @value = Mint::Utils.to_amount(value)
      @currency_sym = normalize_currency(currency)
      @currency = currency.to_s.upcase
    end

    class << self
      extend Forwardable
      # Delegate .conversion_rates class method to Mint::Currency class
      def_delegator :'Mint::Currency', :conversion_rates
    end

    # Dump value with currency name
    # @return [String]
    def inspect
      "#{self} #{currency}"
    end

    # Auto/Stringify instance
    # @return [String]
    def to_s
      format('%.2f', value.to_f)
    end

    # Create new Mint::Money with amount converted to another currency
    # @return [Mint::Money]
    def convert_to(currency, use_base = false)
      Mint::Currency.convert_to(self, currency, use_base)
    end

    # Plus operation
    # @return [Mint::Money]
    def + other
      other = self.class.new(other, @currency_sym) unless other.is_a? self.class
      self.class.new(amount + cast_type(other).amount, @currency_sym)
    end

    # Minus operation
    # @return [Mint::Money]
    def - other
      other = self.class.new(other, @currency_sym) unless other.is_a? self.class
      self.class.new(amount - cast_type(other).amount, @currency_sym)
    end

    # Equal operation
    # Two Mint::Money objects are equal or one of them is a String and looks like .inspect results
    # @return [Boolean]
    def ==(other)
      eql?(other)
    end
    def eql?(other)
      return self.inspect == other if other.class == String

      # what if they are same class just different currencies
      if other.is_a?(self.class) && currency_sym != other.currency_sym
        other = cast_type(other)
      end
      self.class == other.class && amount == other.amount && currency_sym == other.currency_sym
    end

    # Divide operation
    # @return [Mint::Money]
    def / divider
      divider = self.class.new(divider, @currency_sym) unless divider.is_a? self.class
      self.class.new(amount / divider.amount, @currency_sym)
    end

    # Multiplication operation
    # @return [Mint::Money]
    def * mult
      mult = self.class.new(mult, @currency_sym) unless mult.is_a? self.class
      self.class.new(amount * mult.amount, @currency_sym)
    end

    private

    # Convert other Money to the same currency
    # @return [Mint::Money]
    def cast_type(other)
      return Mint::Currency.convert_to(other, @currency_sym) if @currency_sym != other.currency_sym
      other
    end

    # @return [Symbol]
    def normalize_currency(currency = nil)
      currency_sym = Mint::Utils.to_key(currency)
      raise WrongCurrencyError, currency unless Mint::Currency.valid?(currency_sym)
      currency_sym
    end
  end
end
