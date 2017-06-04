# frozen_string_literal: true

RSpec.describe Mint::Utils do
  subject { Mint::Utils }

  describe '.to_amount' do
    it { expect(subject.to_amount(50)).to eq 50.00 }
    it { expect(subject.to_amount('50.00')).to eq 50.00 }
  end

  describe '.to_key' do
    it { expect(subject.to_key('Usd')).to eq :USD }
    it { expect(subject.to_key(:eur)).to eq :EUR }
  end
end
