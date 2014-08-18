require 'test_helper'

require 'wellness/detail'

module Wellness
  class DetailTest < Minitest::Unit::TestCase
    def setup
      @options = {
        a: 'foo'
      }
      @detail = Detail.new(@options)
    end

    def test_initialize
      assert_equal(@options, @detail.options)
    end

    def test_check
      assert_equal({}, @detail.check)
    end

    def test_call
      assert_equal({}, @detail.call)
    end
  end
end
