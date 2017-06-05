# frozen_string_literal: true

RSpec.describe Mint::Currency do
  context 'with .conversion_rates and symbols' do
    let!(:rates) { { USD: 1.1 } }
    before { Mint::Currency.conversion_rates(:eur, rates) }

    it { expect(Mint::Currency.base).to eq 'EUR' }
    it { expect(Mint::Currency.rates).to include(USD: 1.1) }
    it { expect(Mint::Currency.rates).to include(EUR: 1.0) }
  end

  context 'with .conversion_rates and strings' do
    let!(:rates) { { 'USD' => '1.1' } }
    before { Mint::Currency.conversion_rates('EUR', rates) }

    it { expect(Mint::Currency.base).to eq 'EUR' }
    it { expect(Mint::Currency.rates).to include(USD: 1.1) }
    it { expect(Mint::Currency.rates).to include(EUR: 1.0) }
  end

  context 'with .round_precisions and symbols' do
    let!(:precisions) { { LTC: 8, BTC: 8 } }
    before { Mint::Currency.round_precisions(precisions) }

    it { expect(Mint::Currency.precisions).to include(LTC: 8) }
    it { expect(Mint::Currency.precisions).to include(BTC: 8) }
  end

  context 'with .round_precisions and strings' do
    let!(:precisions) { { 'LTC' => 8, 'BTC' => 8 } }
    before { Mint::Currency.round_precisions(precisions) }

    it { expect(Mint::Currency.precisions).to include(LTC: 8) }
    it { expect(Mint::Currency.precisions).to include(BTC: 8) }
  end
end
