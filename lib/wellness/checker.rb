module Wellness

  class Checker
    def initialize(app, system, options={})
      @app = app
      @system = system

      # Optional arguments
      @health_status_path  = options[:status_path]  || '/health/status'
      @health_details_path = options[:details_path] || '/health/details'
    end

    def call(env)
      case env['PATH_INFO']
        when @health_status_path
          health_status(env)
        when @health_details_path
          health_details(env)
        else
          @app.call(env)
      end
    end

    def health_status(env)
      if @system.check
        [200, {'Content-Type' => 'text/json'}, [{status: 'HEALTHY'}.to_json]]
      else
        [500, {'Content-Type' => 'text/json'}, [{status: 'UNHEALTHY'}.to_json]]
      end

    end

    def health_details(env)
      if @system.check
        [200, {'Content-Type' => 'text/json'}, [@system.to_json]]
      else
        [500, {'Content-Type' => 'text/json'}, [@system.to_json]]
      end
    end
  end

end