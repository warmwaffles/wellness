require 'simplecov'
SimpleCov.start do
  add_group('Services', 'wellness/services')
end

require 'rspec'
require 'wellness'
