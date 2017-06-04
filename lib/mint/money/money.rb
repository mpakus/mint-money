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

    # Add operation for same or exchangable Money
    # @return [Mint::Money]
    def + other
      other = self.class.new(other, @currency_sym) if other.class != Mint::Money
      self.class.new(amount + cast_type(other).amount, @currency_sym)
    end

    # Two Mint::Money objects are equal or one of the is String and looks like .inspect results
    # @return [Boolean]
    def ==(other)
      eql?(other)
    end

    def eql?(other)
      return self.inspect == other if other.class == String
      self.class == other.class && amount == other.amount
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
