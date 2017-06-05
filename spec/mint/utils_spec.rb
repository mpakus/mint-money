# frozen_string_literal: true

RSpec.describe Mint::Utils do
  subject { Mint::Utils }

  describe '.to_amount' do
    it { expect(subject.to_amount(50, :USD)).to eq 50.00 }
    it { expect(subject.to_amount('50.00', :USD)).to eq 50.00 }
  end

  describe '.to_key' do
    it { expect(subject.to_key('Usd')).to eq :USD }
    it { expect(subject.to_key(:eur)).to eq :EUR }
  end

  describe '.to_format' do
    it { expect(subject.to_format(100.234, :USD)).to eq '100.23' }
    it 'leaves correct precisions' do
      Mint::Currency.round_precisions(BTC: 8)
      expect(subject.to_format(100.238670958, :USD)).to eq '100.24'
      expect(subject.to_format(100.238670958, :BTC)).to eq '100.23867096'
    end
  end
end
