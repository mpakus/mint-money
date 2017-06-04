# frozen_string_literal: true

RSpec.describe Mint::Currency do
  context 'with .conversion_rates with symbols' do
    let!(:rates) { { USD: 1.1 } }
    before { Mint::Currency.conversion_rates(:eur, rates) }

    it { expect(Mint::Currency.base).to eq 'EUR' }
    it { expect(Mint::Currency.rates).to include(USD: 1.1) }
    it { expect(Mint::Currency.rates).to include(EUR: 1.0) }
  end

  context 'with .conversion_rates with strings' do
    let!(:rates) { { 'USD' => '1.1' } }
    before { Mint::Currency.conversion_rates('EUR', rates) }

    it { expect(Mint::Currency.base).to eq 'EUR' }
    it { expect(Mint::Currency.rates).to include(USD: 1.1) }
    it { expect(Mint::Currency.rates).to include(EUR: 1.0) }
  end
end
