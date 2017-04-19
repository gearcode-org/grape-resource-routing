$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'grape_resource_routing_version'

Gem::Specification.new do |s|
  s.name        = 'grape-resource-routing'
  s.version     = GrapeResourceRouting::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Isac Araujo']
  s.email       = ['isac_lp@yahoo.com.br']
  s.homepage    = 'https://github.com/gearcode-org/grape-resource-routing'
  s.summary     = 'Create resource routes over grape easely.'
  s.description = 'A library to design your routes with regular CRUD schema and more.'
  s.license     = 'MIT'

  s.add_runtime_dependency 'grape', '>= 0.19.2'
  s.add_runtime_dependency 'activerecord', '>= 5.0.2'

  s.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']
end
