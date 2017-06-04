# frozen_string_literal: true

RSpec.describe Mint::Money do
  before { Mint::Money.conversion_rates(:EUR, USD: 1.11, BTC: 0.0047) }
  let!(:fifty_eur) { Mint::Money.new(50, :EUR) }
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

    it { expect(fifty_eur == fifty_eur.convert_to(:USD)).to be_truthy }

    it { expect(twenty_dollars > Mint::Money.new(5, :USD)).to be_truthy }
    it { expect(twenty_dollars < fifty_eur).to be_trythy }
  end

  context 'with arguments errors' do
  end

  context 'with operations exception' do
    describe '#convert_to' do
      it { expect{fifty_eur.convert_to('THB') }.to  raise_error(Mint::WrongCurrencyError) }
    end
  end
end
