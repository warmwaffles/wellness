module Wellness
  # A simple presenter for the services and details of the Wellness System.
  #
  # @author Matthew A. Johnston (warmwaffles)
  class Report
    # @param services [Hash]
    # @param details [Hash]
    def initialize(services, details)
      @services = services
      @details = details
    end

    # @return [Hash]
    def detailed
      {
        status: status,
        services: services,
        details: details
      }
    end

    # @return [Hash]
    def simple
      {
        status: status
      }
    end

    # Returns the {#detailed} hash in json form
    #
    # @return [String]
    def to_json(*)
      detailed.to_json
    end

    # @return [String]
    def status
      healthy? ? 'HEALTHY' : 'UNHEALTHY'
    end

    # @return [Integer]
    def status_code
      healthy? ? 200 : 500
    end

    # @return [TrueClass,FalseClass]
    def healthy?
      @services.all?(&:healthy?)
    end

    def services
      Hash[@services.map { |s| [s.name, s.result] }]
    end

    def details
      Hash[@details.map { |d| [d.name, d.result] }]
    end
  end
end