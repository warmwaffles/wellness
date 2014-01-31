require 'simplecov'
SimpleCov.start do
  add_filter('/spec')
  add_group('Services', 'wellness/services')
end

Dir[Dir.pwd.concat('/spec/support/**/*.rb')].each { |f| require f }

require 'rspec'
require 'wellness'
