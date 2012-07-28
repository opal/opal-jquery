# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opal-jquery/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'opal-jquery'
  s.version      = OpalJQuery::VERSION
  s.author       = 'Adam Beynon'
  s.email        = 'adam@adambeynon.com'
  s.homepage     = 'http://opalrb.org'
  s.summary      = 'Opal access to jquery/zepto'
  s.description  = 'Opal DOM library for jquery/zepto.'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']
end