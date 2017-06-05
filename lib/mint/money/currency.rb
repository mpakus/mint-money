# frozen_string_literal: true

require_relative './utils'
require_relative './exceptions'

module Mint
  # Global Currencies state
  class Currency
    class << self
      attr_accessor :base, :rates, :precisions

      # Setup currency base and conversion rates
      def conversion_rates(base, rates)
        @base = Mint::Utils.to_key(base)
        @rates = Hash[rates.map { |k, v| [Mint::Utils.to_key(k), Mint::Utils.to_amount(v, Mint::Utils.to_key(k))] }]
        @rates[@base] = Mint::Utils.to_amount(1.0, @base)
      end

      # Set round precisions for exceptional currencies like BTC
      # @params precisions [Hash] of currency exception and number of precision e.g. {BTC: 8}
      def round_precisions(precisions)
        @precisions = Hash[precisions.map { |k, v| [Mint::Utils.to_key(k), v.to_i] }]
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

      # Convert Mint::Money object's amount to another currency
      # @TODO: use `use_base` flag try to deep conversion through the currency base
      # @params money [Mint::Money]
      # @params currency [String, Symbol]
      # @params _use_base [Boolean]
      # @return [Mint::Money]
      def convert_to(money, currency, _use_base = false)
        currency_need = Mint::Utils.to_key(currency)
        raise WrongCurrencyError, currency unless Mint::Currency.valid?(currency_need)
        return money if money.currency_sym == currency_need

        rate = calculate_rate(money, currency_need)
        Mint::Money.new(money.amount * rate, currency_need)
      end

      private

      # Find exchange rate
      # @param money [Mint::Money]
      # @param currency_needed [Symbol]
      # @return [BigDecimal]
      def calculate_rate(money, currency_need)
        # when they are not the same currency
        if @base != money.currency_sym
          # but base currency equal to what we need take reverse currency e.g. 1/currency
          return 1 / @rates[money.currency_sym] if @base == currency_need
          raise(WrongConversionError, "#{money.inspect} from #{money.currency_sym} to #{currency_need}")
        end
        @rates[currency_need]
      end
    end
  end
end
