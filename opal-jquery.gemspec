# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opal/jquery/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'opal-jquery'
  s.version      = Opal::JQuery::VERSION
  s.author       = 'Adam Beynon'
  s.email        = 'adam.beynon@gmail.com'
  s.homepage     = 'http://opalrb.org'
  s.summary      = 'Opal access to jquery'
  s.description  = 'Opal DOM library for jquery'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'opal', '~> 0.7.0.dev'
  s.add_development_dependency 'opal-rspec', '~> 0.4.0.beta2'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rake'
end
