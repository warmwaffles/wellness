require 'spec_helper'

describe Wellness::System do
  let(:system) { described_class.new('test_system') }

  describe '#use' do
    context 'when a Wellness::Services::Base is provided' do
      subject { system.use(HealthyService, 'test_service') }
      it 'adds the service to the list of services' do
        expect { subject }.to change { system.services.count }.by(1)
      end
    end
    context 'when a Wellness::Detail is provided' do
      subject { system.use(MockedDetail, 'test_detail') }
      it 'adds the detail to the list of details' do
        expect { subject }.to change { system.details.count }.by(1)
      end
    end
  end

  describe '#build_report' do
    subject { system.build_report }
    it 'returns a Wellness::Report' do
      expect(subject).to be_a(Wellness::Report)
    end
  end

  describe '#detailed_check' do
    let(:headers) { { 'Content-Type' => 'application/json' } }
    subject { system.detailed_check }

    context 'when the check is HEALTHY' do
      before { system.use(HealthyService, 'test_service') }

      it 'responds with a 200' do
        expect(subject[0]).to eq(200)
      end
      it 'sets the "Content-Type" to "application/json"' do
        expect(subject[1]).to eq(headers)
      end
    end
    context 'when the check is UNHEALTHY' do
      before { system.use(UnhealthyService, 'test_service') }

      it 'responds with a 500' do
        expect(subject[0]).to eq(500)
      end
      it 'sets the "Content-Type" to "application/json"' do
        expect(subject[1]).to eq(headers)
      end
    end
  end

  describe '#simple_check' do
    let(:headers) { { 'Content-Type' => 'application/json' } }
    subject { system.simple_check }
    context 'when the check is HEALTHY' do
      before { system.use(HealthyService, 'test_service') }

      it 'responds with a 200' do
        expect(subject[0]).to eq(200)
      end
      it 'sets the "Content-Type" to "application/json"' do
        expect(subject[1]).to eq(headers)
      end
    end
    context 'when the check is UNHEALTHY' do
      before { system.use(UnhealthyService, 'test_service') }

      it 'responds with a 500' do
        expect(subject[0]).to eq(500)
      end
      it 'sets the "Content-Type" to "application/json"' do
        expect(subject[1]).to eq(headers)
      end
    end
  end
end