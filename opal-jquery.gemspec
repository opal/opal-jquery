# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opal/jquery/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'opal-jquery'
  s.version      = Opal::JQuery::VERSION
  s.authors      = ['Adam Beynon', 'Elia Schito']
  s.email        = 'elia@schito.me'
  s.homepage     = 'https://github.com/opal/opal-jquery#readme'
  s.summary      = 'Opal access to jQuery'
  s.description  = 'Opal DOM library for jQuery'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'opal', '>= 0.10.0', '< 1.1'
  s.add_development_dependency 'opal-rspec', '~> 0.7.0'
  s.add_development_dependency 'opal-sprockets', '~> 0.4.1'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rake'
end
