# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require_relative './exceptions'

module Mint
  # Special utilities
  class Utils
    class << self
      # Normalize string to our currency key format ex. 'usd' -> :USD
      # @return [Symbol]
      def to_key(key)
        key.to_s.upcase.to_sym
      end

      # Normalize and try to guess amount type ex '1.178' -> <BigDecimal: 1.18>
      # @return [BigDecimal]
      def to_amount(value)
        to_bigdecimal(value).round(2)
      end

      private

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
