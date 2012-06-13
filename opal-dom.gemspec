# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opal/dom/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'opal-dom'
  s.version      = DOM::VERSION
  s.author       = 'Adam Beynon'
  s.email        = 'adam@adambeynon.com'
  s.homepage     = 'http://opalrb.org'
  s.summary      = 'DOM Library for Opal'
  s.description  = 'Opal DOM Library'

  s.files          = `git ls-files`.split("\n")
  s.require_paths  = ['lib']
end