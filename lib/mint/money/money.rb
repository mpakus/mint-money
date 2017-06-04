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

    private

    # @return [Symbol]
    def normalize_currency(currency = nil)
      currency_sym = Mint::Utils.to_key(currency)
      raise WrongCurrencyError, currency unless Mint::Currency.valid?(currency_sym)
      currency_sym
    end
  end
end
