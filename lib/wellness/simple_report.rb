require 'json'

module Wellness
  class SimpleReport
    STATUSES = {
      'HEALTHY' => 200,
      'DEGRADED' => 200,
      'UNHEALTHY' => 500
    }

    def initialize(system)
      @system = system
    end

    def call
      non_criticals = []
      criticals = []

      @system.services.each do |name, service|
        result = service.call['status']

        if service.critical?
          criticals << result
        else
          non_criticals << result
        end
      end

      healthy = criticals.all? { |s| s == 'HEALTHY' }
      degraded = non_criticals.any? { |s| s == 'UNHEALTHY' }

      if healthy
        if degraded
          status = 'DEGRADED'
        else
          status = 'HEALTHY'
        end
      else
        status = 'UNHEALTHY'
      end

      render({json: { 'status' => status }, status: STATUSES[status]})
    end

    # Behaves similar to Rail's controller render method
    def render(options={})
      status   = options[:status]  || 200
      response = JSON.dump(options[:json])

      [status, { 'Content-Type' => 'application/json' }, [response]]
    end
  end
end
