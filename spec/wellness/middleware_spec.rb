require 'spec_helper'

describe Wellness::Middleware do
  let(:app) { double('Application') }
  let(:system) { Wellness::System.new('test_system') }

  describe '#health_status_path' do
    subject { middleware.health_status_path }
    context 'when the status_path is not passed' do
      let(:middleware) { described_class.new(app, system) }
      it 'returns "/health/status"' do
        expect(subject).to eq('/health/status')
      end
    end
    context 'when the status_path is passed' do
      let(:options) { {status_path: '/path/to/status' } }
      let(:middleware) { described_class.new(app, system, options) }
      it 'returns "/path/to/status"' do
        expect(subject).to eq('/path/to/status')
      end
    end
  end

  describe '#health_details_path' do
    context 'when the details_path is not passed' do
      let(:middleware) { described_class.new(app, system) }
      subject { middleware.health_details_path }
      it 'returns "/health/details"' do
        expect(subject).to eq('/health/details')
      end
    end
    context 'when the details_path is passed' do
      let(:options) { {details_path: '/path/to/status' } }
      let(:middleware) { described_class.new(app, system, options) }
      subject { middleware.health_details_path }
      it 'returns "/path/to/status"' do
        expect(subject).to eq('/path/to/status')
      end
    end
  end

  describe '#call' do
    let(:middleware) { described_class.new(app, system) }
    context 'when the PATH_INFO matches the health_status_path' do
      let(:env) { { 'PATH_INFO' => '/health/status' } }
      before { system.stub(simple_check: true) }
      it 'calls #simple_check on the system' do
        middleware.call(env)
        expect(system).to have_received(:simple_check).once
      end
    end
    context 'when the PATH_INFO matches the health_details_path' do
      let(:env) { { 'PATH_INFO' => '/health/details' } }
      before { system.stub(detailed_check: true) }
      it 'calls #detailed_check on the system' do
        middleware.call(env)
        expect(system).to have_received(:detailed_check).once
      end
    end
    context 'when the PATH_INFO doesn\'t match any of the paths' do
      let(:env) { { 'PATH_INFO' => '/different/path' } }
      before { app.stub(call: true) }
      it 'calls #detailed_check on the system' do
        middleware.call(env)
        expect(app).to have_received(:call).with(env)
      end
    end
  end
end
