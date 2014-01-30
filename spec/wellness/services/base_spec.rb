require 'spec_helper'

describe Wellness::Services::Base do
  let(:params) { { test: 'data' } }
  let(:service) { described_class.new(params) }
  describe '#failed_check' do
    before { service.passed_check }
    subject { service.failed_check }
    it 'returns false' do
      expect(subject).to eq(false)
    end
    it 'flags the service as unhealthy' do
      expect { subject }.to change(service, :healthy?).from(true).to(false)
    end
  end

  describe '#passed_check' do
    subject { service.passed_check }
    it 'returns true' do
      expect(subject).to eq(true)
    end
    it 'flags the service as healthy' do
      expect { subject }.to change(service, :healthy?).from(false).to(true)
    end
  end

  describe '#params' do
    subject { service.params }
    it 'returns the params that it was constructed with' do
      expect(subject).to eq(params)
    end
  end

  describe '#check' do
    subject { service.check }
    it 'returns an empty hash' do
      expect(subject).to eq({})
    end
  end
end