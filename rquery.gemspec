# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name         = "rquery"
  s.version      = "0.0.1"
  s.authors      = ["Adam Beynon"]
  s.email        = ["adam@adambeynon.com"]
  s.homepage     = "http://github.com/adambeynon/opal"
  s.summary      = "Rquery DOM library for ruby/opal"

  s.files        = Dir.glob("{bin,lib}/**/*") + %w[README.md]
  s.require_path = "lib"

  s.add_dependency "json"
end

