module Wellness

  class Checker
    def initialize(app, system)
      @app = app
      @system = system
    end

    def call(env)
      case env['PATH_INFO']
        when '/health/status'
          health_status(env)
        when '/health/details'
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