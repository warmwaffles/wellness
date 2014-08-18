require 'json'

module Wellness
  class DetailedReport
    STATUSES = {
      'HEALTHY' => 200,
      'DEGRADED' => 500,
      'UNHEALTHY' => 500
    }

    def initialize(system)
      @system = system
    end

    def call
      non_criticals = []
      criticals = []

      services = {}
      @system.services.each do |name, service|
        services[name] = service.call

        if service.critical?
          criticals << services[name]['status']
        else
          non_criticals << services[name]['status']
        end
      end

      details = {}
      @system.details.each do |name, detail|
        details[name] = detail.call
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

      results = {
        'status'   => status,
        'services' => services,
        'details'  => details
      }

      render({json: results, status: STATUSES[status]})
    end

    def render(options={})
      status   = options[:status]  || 200
      response = JSON.dump(options[:json])

      [status, { 'Content-Type' => 'application/json' }, [response]]
    end
  end
end
