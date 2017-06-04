# frozen_string_literal: true

require_relative './utils'
require_relative './exceptions'

module Mint
  # Global Currencies state
  class Currency
    class << self
      attr_accessor :base, :rates

      # Setup currency base and conversion rates
      def conversion_rates(base, rates)
        @base = Mint::Utils.to_key(base)
        @rates = Hash[rates.map { |k, v| [Mint::Utils.to_key(k), Mint::Utils.to_amount(v)] }]
        @rates[@base] = Mint::Utils.to_amount(1.0)
      end

      # @return [String]
      def base
        @base.to_s
      end

      # Checks if currency exists in our conversion rates hash
      # @return [Boolean]
      def valid?(currency)
        @rates.key?(currency)
      end

      # @return [Mint::Money]
      def convert_to(money, currency, use_base = false)
        currency_sym = Mint::Utils.to_key(currency)
        raise WrongCurrencyError, currency unless Mint::Currency.valid?(currency_sym)
        return money if money.currency_sym == currency_sym # if same currency
        raise(WrongConversionError, money, money.currency_sym, currency_sym) if !use_base && @base != money.currency_sym
        Mint::Money.new(money.amount * @rates[currency_sym], currency_sym)
      end
    end
  end
end
