require 'spec_helper'

describe Wellness::Middleware do
  let(:app) { double('Application', call: true) }
  let(:system) { Wellness::System.new('testing') }
  let(:middleware) { Wellness::Middleware.new(app, system) }

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

  describe '#call' do
    context 'when the PATH_INFO is the health status path' do
      let(:env) { { 'PATH_INFO' => '/health/status' } }
      subject { middleware.call(env) }

      context 'when the system check is unhealthy' do
        before { system.stub(check: false) }

        it 'returns a 500 status' do
          expect(subject[0]).to eq(500)
        end

        it 'returns a json content type' do
          expect(subject[1]).to eq({ 'Content-Type' => 'text/json' })
        end

        it 'returns UNHEALTHY' do
          data = JSON.parse(subject[2].first)
          expect(data).to eq({ 'status' => 'UNHEALTHY' })
        end
      end

      context 'when the system check is healthy' do
        before { system.stub(check: true) }

        it 'returns a 200 status' do
          expect(subject[0]).to eq(200)
        end

        it 'returns a json content type' do
          expect(subject[1]).to eq({ 'Content-Type' => 'text/json' })
        end

        it 'returns HEALTHY' do
          data = JSON.parse(subject[2].first)
          expect(data).to eq({ 'status' => 'HEALTHY' })
        end
      end
    end

    context 'when the PATH_INFO is the health details path' do
      let(:env) { { 'PATH_INFO' => '/health/details' } }
      subject { middleware.call(env) }

      context 'when the system check is unhealthy' do
        before do
          system.add_service('mock service', FailingMockService.new)
        end

        it 'returns a 500 status' do
          expect(subject[0]).to eq(500)
        end

        it 'returns a json content type' do
          expect(subject[1]).to eq({ 'Content-Type' => 'text/json' })
        end

        it 'returns UNHEALTHY' do
          expected = {
            'status' => 'UNHEALTHY',
            'details' => {},
            'dependencies' => {
              'mock service' => {
                'status' => 'UNHEALTHY',
                'details' => {}
              }
            }
          }

          data = JSON.parse(subject[2].first)
          expect(data).to eq(expected)
        end
      end
      context 'when the system check is healthy' do
        before do
          system.add_service('mock service', PassingMockService.new)
        end

        it 'returns a 200 status' do
          expect(subject[0]).to eq(200)
        end

        it 'returns a json content type' do
          expect(subject[1]).to eq({ 'Content-Type' => 'text/json' })
        end

        it 'returns UNHEALTHY' do
          expected = {
            'status' => 'HEALTHY',
            'details' => {},
            'dependencies' => {
              'mock service' => {
                'status' => 'HEALTHY',
                'details' => {}
              }
            }
          }

          data = JSON.parse(subject[2].first)
          expect(data).to eq(expected)
        end
      end
    end

    context 'when the PATH_INFO is /who/cares' do
      let(:env) { { 'PATH_INFO' => '/who/cares' } }

      it 'passes the request to the next rack' do
        middleware.call(env)
        expect(app).to have_received(:call).with(env)
      end
    end
  end
end
