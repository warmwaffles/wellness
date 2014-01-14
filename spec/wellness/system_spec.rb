require 'spec_helper'

describe Wellness::System do
  let(:name) { 'testing-app' }
  let(:system) { described_class.new(name) }

  describe '#name' do
    subject { system.name }
    it 'equals "testing-app"' do
      expect(subject).to eq(name)
    end
  end

  describe '#add_service' do
    let(:service) { double('Service')  }
    subject { system.add_service('foo', service) }

    it 'adds the service to the system' do
      expect { subject }.to change(system.services, :length).to(1)
    end
  end

  describe '#remove_service' do
    let(:service) { double('Service')  }
    subject { system.remove_service('foo') }
    before { system.add_service('foo', service) }
    it 'removes the service from the system' do
      expect { subject }.to change(system.services, :length).to(0)
    end
  end

end