# frozen_string_literal: true

module Mint
  # When currency type is unrecognized
  class WrongCurrencyError < ArgumentError
    def initialize(value)
      super "Can't find #{value} currency, please setup it with Mint::Money.conversion.rates"
    end
  end

  # When money type is unrecognized
  class WrongMoneyError < TypeError
    def initialize(value)
      super "Wrong amount's type #{value.inspect}, should be Float, BigDecimal or Mint::Money"
    end
  end
end
