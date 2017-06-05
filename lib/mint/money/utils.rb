# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require_relative './exceptions'

module Mint
  # Special utilities
  class Utils
    class << self
      # Normalize string to our keys format
      # @example
      #   'usd' -> :USD
      # @param [String,Symbol]
      # @return [Symbol]
      def to_key(key)
        key.to_s.upcase.to_sym
      end

      # Normalize and guess amount's type
      # @example
      #   '1.178' -> <BigDecimal: 1.18>
      # @param value [BigDecimal]
      # @param currency [Symbol]
      # @return [BigDecimal]
      def to_amount(value, currency)
        to_bigdecimal(value).round(precision(currency))
      end

      # Format number as string with correct precision
      # @param value [BigDecimal]
      # @param currency [Symbol]
      # @return [String]
      def to_format(value, currency)
        format("%.#{precision(currency)}f", value.to_f)
      end

      private

      # Return precision for round or default is 2
      # @param currency [String,Symbol]
      # @return [Integer]
      def precision(currency)
        (Mint::Currency.precisions || {}).fetch(to_key(currency), 2)
      end

      # Trying to guess type
      # @param value [Mixed]
      # @return [BigDecimal]
      def to_bigdecimal(value)
        case value
        when Mint::Money
          value.value
        when Rational
          value.to_d(16)
        else
          value.respond_to?(:to_d) ? value.to_d : raise(WrongMoneyError, value)
        end
      end
    end
  end
end
