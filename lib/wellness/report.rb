module Wellness
  # A simple presenter for the services and details of the Wellness System.
  # This does not contain any logic for running checks and gathering details,
  # simply because the details and results should be passed in.
  #
  # @author Matthew A. Johnston (warmwaffles)
  class Report
    # @param services [Hash]
    # @param details [Hash]
    def initialize(services={}, details={})
      @services = services
      @details = details
    end

    # @return [Hash]
    def detailed
      {
        status: status,
        services: @services,
        details: @details
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
      @services.values.all? { |h| h[:status] == 'HEALTHY' }
    end
  end
end