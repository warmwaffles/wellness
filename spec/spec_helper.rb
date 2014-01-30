require 'simplecov'
SimpleCov.start do
  add_filter('/spec')
  add_group('Services', 'wellness/services')
end

require 'rspec'
require 'wellness'
