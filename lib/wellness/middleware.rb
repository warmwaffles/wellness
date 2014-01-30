module Wellness
  # This is to be put into the Rack environment.
  #
  # @author Matthew A. Johnston
  class Middleware
    def initialize(app, system, options={})
      @app = app
      @system = system

      # Optional arguments
      @health_status_path = options[:status_path] || '/health/status'
      @health_details_path = options[:details_path] || '/health/details'
    end

    def call(env)
      case env['PATH_INFO']
      when @health_status_path
        health_status_check
      when @health_details_path
        health_details_check
      else
        @app.call(env)
      end
    end

    private

    def health_status_check
      if @system.check
        [200, { 'Content-Type' => 'application/json' }, [{ status: 'HEALTHY' }.to_json]]
      else
        [500, { 'Content-Type' => 'application/json' }, [{ status: 'UNHEALTHY' }.to_json]]
      end
    end

    def health_details_check
      if @system.check
        [200, { 'Content-Type' => 'application/json' }, [@system.to_json]]
      else
        [500, { 'Content-Type' => 'application/json' }, [@system.to_json]]
      end
    end
  end
end