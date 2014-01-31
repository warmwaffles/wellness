require 'json'

module Wellness
  VERSION = '1.0.0'

  autoload :Services,   'wellness/services'
  autoload :Middleware, 'wellness/middleware'
  autoload :System,     'wellness/system'
  autoload :Detail,     'wellness/detail'
  autoload :Report,     'wellness/report'
  autoload :Factory,    'wellness/factory'
end
