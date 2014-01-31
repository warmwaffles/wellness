require 'spec_helper'

describe Wellness::Services::Base do
  let(:params) { { foo: 'bar' } }
  let(:service) { described_class.new(params) }

  describe '#healthy?' do
    subject { service.healthy? }
    context 'when the status key is missing' do
      before { service.result.delete(:status) }
      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
    context 'when the status is UNHEALTHY' do
      before { service.result[:status] = 'UNHEALTHY' }
      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
    context 'when the status is HEALTHY' do
      before { service.result[:status] = 'HEALTHY' }
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#call' do
    let(:result) { {status: 'HEALTHY'} }
    subject { service.call }

    before { service.stub(check: result) }

    it 'receives the #call method' do
      subject
      expect(service).to have_received(:check).once
    end

    it 'sets the result' do
      expect { subject }.to change { service.result }.to(result)
    end
  end

  describe '#check' do
    subject { service.check }
    it 'returns a status of UNHEALTHY' do
      expect(subject).to include(status: 'UNHEALTHY')
    end
  end
end