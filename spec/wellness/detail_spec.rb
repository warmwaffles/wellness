require 'spec_helper'

describe Wellness::Detail do
  let(:detail) { described_class.new('test_detail') }

  describe '#name' do
    subject { detail.name }
    it 'returns "test_detail"' do
      expect(subject).to eq('test_detail')
    end
  end

  describe '#call' do
    subject { detail.call }
    it 'returns an empty hash' do
      expect(subject).to be_empty
    end
  end
end
