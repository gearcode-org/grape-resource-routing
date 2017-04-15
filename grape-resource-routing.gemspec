$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'grape/version'

Gem::Specification.new do |s|
  s.name        = 'grape-resource-routing'
  s.version     = Grape::ResourceRouting::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Isac Araujo']
  s.email       = ['isac_lp@yahoo.com.br']
  s.homepage    = 'https://github.com/isacaraujo/grape-resource-routing'
  s.summary     = 'Create resource routes over grape easely.'
  s.description = 'A library to adapt your grape API with routes.'
  s.license     = 'MIT'

  s.add_runtime_dependency 'grape', '>= 0.19.2'

  s.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']
end
