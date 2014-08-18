require 'test_helper'
require 'wellness/system'
require 'wellness/simple_report'

module Wellness
  class SimpleReportTest < Minitest::Unit::TestCase
    def build_report(system)
      Wellness::SimpleReport.new(system)
    end

    def test_call
      system = Wellness::System.new('Healthy System')
      system = System.new('Test System')
      system.add_service('foo', healthy, { critical: true })
      system.add_service('bar', healthy, { critical: true })
      system.add_detail('something', some_detail)

      result = build_report(system).call

      status  = result[0]
      headers = result[1]
      content = JSON.parse(result[2].last)

      assert_equal(200, status)
      assert_equal('HEALTHY', content['status'])

      # ###################################################

      system = Wellness::System.new('Unhealthy System')
      system = System.new('Test System')
      system.add_service('foo', unhealthy, { critical: true })
      system.add_service('bar', healthy, { critical: true })
      system.add_detail('something', some_detail)

      result = build_report(system).call

      status  = result[0]
      headers = result[1]
      content = JSON.parse(result[2].last)

      assert_equal(500, status)
      assert_equal('UNHEALTHY', content['status'])

      # ###################################################

      system = Wellness::System.new('Degraded System')
      system = System.new('Test System')
      system.add_service('foo', unhealthy, { critical: false })
      system.add_service('bar', healthy, { critical: true })
      system.add_detail('something', some_detail)

      result = build_report(system).call

      status  = result[0]
      headers = result[1]
      content = JSON.parse(result[2].last)

      assert_equal(200, status)
      assert_equal('DEGRADED', content['status'])

      # ###################################################

      system = Wellness::System.new('Unhealthy System')
      system = System.new('Test System')
      system.add_service('foo', unhealthy, { critical: true })
      system.add_service('bar', unhealthy, { critical: true })
      system.add_detail('something', some_detail)

      result = build_report(system).call

      status  = result[0]
      headers = result[1]
      content = JSON.parse(result[2].last)

      assert_equal(500, status)
      assert_equal('UNHEALTHY', content['status'])

      # ###################################################

      system = Wellness::System.new('Degraded System')
      system = System.new('Test System')
      system.add_service('foo', unhealthy, { critical: false })
      system.add_service('bar', unhealthy, { critical: false })
      system.add_detail('something', some_detail)

      result = build_report(system).call

      status  = result[0]
      headers = result[1]
      content = JSON.parse(result[2].last)

      assert_equal(200, status)
      assert_equal('DEGRADED', content['status'])
    end

    def unhealthy
      Proc.new do
        {
          'status' => 'UNHEALTHY',
          'details' => {
            'something' => 1
          }
        }
      end
    end

    def healthy
      Proc.new do
        {
          'status' => 'HEALTHY',
          'details' => {
            'something' => 0
          }
        }
      end
    end

    def some_detail
      Proc.new do
        {
          'foo' => 1,
          'bar' => 0
        }
      end
    end
  end
end
