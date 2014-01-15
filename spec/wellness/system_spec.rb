require 'spec_helper'

describe Wellness::System do
  let(:name) { 'testing-app' }
  let(:system) { described_class.new(name) }

  class PassingMockService < Wellness::Services::Base
    def check
      passed_check
      {
        'status' => 'HEALTHY',
        'details' => {}
      }
    end
  end

  class FailingMockService < Wellness::Services::Base
    def check
      failed_check
      {
        'status' => 'UNHEALTHY',
        'details' => {}
      }
    end
  end

  describe '#name' do
    subject { system.name }
    it 'equals "testing-app"' do
      expect(subject).to eq(name)
    end
  end

  describe '#add_service' do
    let(:service) { double('Service') }
    subject { system.add_service('foo', service) }

    it 'adds the service to the system' do
      expect { subject }.to change(system.services, :length).to(1)
    end
  end

  describe '#remove_service' do
    let(:service) { double('Service') }
    subject { system.remove_service('foo') }
    before { system.add_service('foo', service) }
    it 'removes the service from the system' do
      expect { subject }.to change(system.services, :length).to(0)
    end
  end

  describe '#check' do
    subject { system.check }

    context 'when no services are registered' do
      it 'returns true' do
        expect(subject).to be_true
      end
    end

    context 'when a passing service is registered' do
      before { system.add_service('passing', PassingMockService.new) }

      it 'returns true' do
        expect(subject).to be_true
      end
    end

    context 'when a failing service is registered' do
      before { system.add_service('failing', FailingMockService.new) }

      it 'returns false' do
        expect(subject).to be_false
      end
    end

    context 'when one service is failing and the other is passing' do
      before do
        system.add_service('passing', PassingMockService.new)
        system.add_service('failing', FailingMockService.new)
      end

      it 'returns false' do
        expect(subject).to be_false
      end
    end

    context 'when all services are passing' do
      before do
        system.add_service('passing one', PassingMockService.new)
        system.add_service('passing two', PassingMockService.new)
      end

      it 'returns true' do
        expect(subject).to be_true
      end
    end
  end

end