# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wellness/version'

Gem::Specification.new do |spec|
  spec.name          = 'wellness'
  spec.version       = Wellness::VERSION
  spec.authors       = ['Matthew Johnston']
  spec.email         = ['warmwaffles@gmail.com']
  spec.description   = 'A rack middleware health check'
  spec.summary       = 'A rack middleware health check'
  spec.homepage      = 'https://github.com/warmwaffles/wellness'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('rake')

  # service dependencies
  spec.add_development_dependency('pg')
  spec.add_development_dependency('sidekiq')
  spec.add_development_dependency('redis')
end
