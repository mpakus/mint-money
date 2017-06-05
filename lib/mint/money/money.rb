# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require 'forwardable'
require_relative './currency'
require_relative './exceptions'
require_relative './utils'

module Mint
  # Minty Money Management
  #
  # @author Renat Ibragimov <renat@aomega.co>
  #
  # @see https://github.com/mpakus/mint-money
  class Money
    include Comparable

    attr_reader :value, :currency, :currency_sym
    alias amount value

    # @param value [Integer]
    # @param currency [String,Symbol]
    # @return [Mint::Money]
    def initialize(value = 0.00, currency = nil)
      @currency_sym = normalize_currency(currency)
      @currency = currency.to_s.upcase
      @value = Mint::Utils.to_amount(value, @currency_sym)
    end

    class << self
      extend Forwardable
      # Delegate .conversion_rates class method to Mint::Currency class
      def_delegator :'Mint::Currency', :conversion_rates
      def_delegator :'Mint::Currency', :round_precisions
    end

    # Returns formatted value and currency name
    # @return [String]
    def inspect
      "#{self} #{currency}"
    end

    # Auto/Stringify instance
    # @return [String]
    def to_s
      Mint::Utils.to_format(value, currency_sym)
    end

    # Create new Mint::Money with amount converted to another currency
    # @param currency [Symbol]
    # @param use_base [Boolean]
    # @return [Mint::Money]
    def convert_to(currency, use_base = false)
      Mint::Currency.convert_to(self, currency, use_base)
    end

    # Plus operation
    # @return [Mint::Money]
    def +(other)
      other = self.class.new(other, @currency_sym) unless other.is_a? self.class
      self.class.new(amount + cast_type(other).amount, @currency_sym)
    end

    # Minus operation
    # @return [Mint::Money]
    def -(other)
      other = self.class.new(other, @currency_sym) unless other.is_a? self.class
      self.class.new(amount - cast_type(other).amount, @currency_sym)
    end

    # Equal operation
    # Two Mint::Money objects are equal or one of them is a String and looks like .inspect results
    # @return [Boolean]
    def ==(other)
      eql?(other)
    end

    # rubocop:disable all
    # @return [Boolean]
    def eql?(other)
      return inspect == other if other.class == String
      # what if they are same class just different currencies
      other = cast_type(other) if other.is_a?(self.class) && currency_sym != other.currency_sym
      self.class == other.class && amount == other.amount && currency_sym == other.currency_sym
    end
    # rubocop:enable all

    # Divide operation
    # @return [Mint::Money]
    def /(other)
      other = self.class.new(other, @currency_sym) unless other.is_a? self.class
      self.class.new(amount / other.amount, @currency_sym)
    end

    # Multiplication operation
    # @return [Mint::Money]
    def *(other)
      other = self.class.new(other, @currency_sym) unless other.is_a? self.class
      self.class.new(amount * other.amount, @currency_sym)
    end

    # Lower and bigger (sort, spaceship) operation
    # @return [boolean]
    def <=>(other)
      other = self.class.new(other, @currency_sym) unless other.is_a? self.class
      amount <=> other.amount
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
