require 'rubygems'
require 'bundler'

require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/pride'

Bundler.require

Dir.glob('./support/**/*.rb') { |f| require f }
