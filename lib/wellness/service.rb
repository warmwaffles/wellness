module Wellness
  # Wraps a callable object.
  class Service
    def initialize(callable, options={})
      @callable = callable
      @critical = options.fetch(:critical, true)
    end

    def critical?
      !!@critical
    end

    def call
      @callable.call
    end
  end
end
