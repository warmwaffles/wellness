require 'simplecov'
SimpleCov.start do
  add_filter('/spec')
  add_group('Services', 'wellness/services')
end

require 'rspec'
require 'wellness'

Dir[Dir.pwd.concat('/spec/support/**/*.rb')].each { |f| require f }
