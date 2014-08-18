require 'test_helper'

require 'wellness/system'

module Wellness
  class SystemTest < Minitest::Unit::TestCase
    def test_add_service
      system = System.new('Test System')
      service = Proc.new do
        raise(RuntimeError, 'called when it should not be')
      end
      system.add_service('test', service)
    end

    def test_add_detail
      system = System.new('Test System')
      detail = Proc.new do
        raise(RuntimeError, 'called when it should not be')
      end
      system.add_detail('test', detail)
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
