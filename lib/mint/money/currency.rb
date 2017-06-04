# frozen_string_literal: true

require_relative './utils'

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
    end
  end
end
