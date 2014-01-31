class UnhealthyService < Wellness::Services::Base
  def check
    { status: 'UNHEALTHY' }
  end
end

class HealthyService < Wellness::Services::Base
  def check
    { status: 'HEALTHY' }
  end
end

class MockedDetail < Wellness::Detail
  def check
    { 'data' => 'here' }
  end
end
