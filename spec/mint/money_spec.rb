# frozen_string_literal: true

RSpec.describe Mint::Money do
  before do
    Mint::Money.round_precisions(BTC: 8)
    Mint::Money.conversion_rates(:EUR, USD: 1.11, BTC: 0.00044)
  end
  let!(:fifty_eur) { Mint::Money.new(50, :EUR) }
  let!(:fifty_eur_in_usd) { fifty_eur.convert_to(:USD) }
  let!(:twenty_dollars) { Mint::Money.new(20, :USD) }

  context 'with initial object' do
    subject { fifty_eur }

    it { expect(subject.amount).to eq 50 }
    it { expect(subject.currency).to eq 'EUR' }
    it { expect(subject.inspect).to eq '50.00 EUR' }
  end

  context 'with conversion' do
    subject { fifty_eur.convert_to('USD') }

    it { expect(subject.amount).to eq 55.50 }
    it { expect(subject.currency).to eq 'USD' }
    it { expect(subject.inspect).to eq '55.50 USD' }
  end

  context 'with different currency operations' do
    it { expect(fifty_eur + twenty_dollars).to eq '68.02 EUR' }
    it { expect(fifty_eur + 5).to eq '55.00 EUR' }
    it { expect(fifty_eur - twenty_dollars).to eq '31.98 EUR' }
    it { expect(fifty_eur - 5).to eq '45.00 EUR' }
    it { expect(fifty_eur / 2).to eq '25.00 EUR' }
    it { expect(twenty_dollars * 3).to eq '60.00 USD' }
  end

  context 'with comparisons operations' do
    it { expect(twenty_dollars == Mint::Money.new(20, :USD)).to be_truthy }
    it { expect(twenty_dollars == Mint::Money.new(30, :USD)).to be_falsey }

    it { expect(fifty_eur == fifty_eur_in_usd).to be_truthy }
    it { expect(fifty_eur_in_usd == fifty_eur).to be_truthy }

    it { expect(twenty_dollars > Mint::Money.new(5, :USD)).to be_truthy }
    it { expect(twenty_dollars < fifty_eur).to be_truthy }
    it { expect(fifty_eur > twenty_dollars).to be_truthy }
  end

  context 'with different rounding precisions' do
    it { expect(Mint::Money.new(10, :EUR).convert_to(:BTC)).to eq   '0.00440000 BTC' }
    it { expect(Mint::Money.new(100, :EUR).convert_to(:BTC)).to eq  '0.04400000 BTC' }
    it { expect(Mint::Money.new(1000, :EUR).convert_to(:BTC)).to eq '0.44000000 BTC' }
    it { expect(Mint::Money.new(1000, :BTC).convert_to(:EUR)).to eq '2272727.27 EUR' }
  end

  context 'with exceptions' do
    describe '.new' do
      it { expect { Mint::Money.new(Mint::Currency, :USD) }.to raise_error(Mint::WrongMoneyError) }
    end
    describe '#convert_to' do
      it { expect { fifty_eur.convert_to('THB') }.to raise_error(Mint::WrongCurrencyError) }
      it { expect { twenty_dollars.convert_to('BTC') }.to raise_error(Mint::WrongConversionError) }
    end
  end
end
