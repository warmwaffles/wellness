require 'spec_helper'

describe Wellness::Detail do
  let(:detail) { MockedDetail.new('test_detail') }

  describe '#name' do
    subject { detail.name }
    it 'returns "test_detail"' do
      expect(subject).to eq('test_detail')
    end
  end

  describe '#call' do
    subject { detail.call }
    it 'sets the result' do
      expect { subject }.to change(detail, :result)
    end
  end

  describe '#check' do
    subject { detail.check }
    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end
  end
end
