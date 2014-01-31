require 'spec_helper'

describe Wellness::Report do
  let(:report) { described_class.new({}, {}) }

  describe '#to_json' do
    subject { report.to_json }
    it 'returns a json string' do
      expect(JSON.parse(subject)).to be_a(Hash)
    end
  end

  describe '#detailed' do
    subject { report.detailed }
    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end
  end

  describe '#simple' do
    subject { report.simple }
    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end
  end

  describe '#status' do
    subject { report.status }
    context 'when the report is healthy' do
      before { report.stub(:healthy? => true) }
      it 'returns HEALTHY' do
        expect(subject).to eq('HEALTHY')
      end
    end
    context 'when the report is not healthy' do
      before { report.stub(:healthy? => false) }
      it 'returns UNHEALTHY' do
        expect(subject).to eq('UNHEALTHY')
      end
    end
  end

  describe '#status_code' do
    subject { report.status_code }
    context 'when the report is healthy' do
      before { report.stub(:healthy? => true) }
      it 'returns 200' do
        expect(subject).to eq(200)
      end
    end
    context 'when the report is not healthy' do
      before { report.stub(:healthy? => false) }
      it 'returns 500' do
        expect(subject).to eq(500)
      end
    end
  end

  describe '#healthy?' do
    subject { report.healthy? }
    context 'when all of the report are healthy' do
      let(:services) { [HealthyService.new('service-a'), HealthyService.new('service-b')] }
      let(:report) { described_class.new(services, []) }
      before { services.collect(&:call) }
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
    context 'when one of the reports are not healthy' do
      let(:services) { [HealthyService.new('service-a'), UnhealthyService.new('service-b')] }
      let(:report) { described_class.new(services, []) }
      before { services.collect(&:call) }
      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
    context 'when all of the reports are not healthy' do
      let(:services) { [UnhealthyService.new('service-a'), UnhealthyService.new('service-b')] }
      let(:report) { described_class.new(services, []) }
      before { services.collect(&:call) }
      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end
end

