require 'opal'

VERSION = File.read("VERSION").strip

copyright = <<-EOS
/*!
 * RQuery v#{VERSION}
 * http://opalscript.org
 * Copyright 2011, Adam Beynon
 * Released under the MIT license.
 *
 * Includes Opal
 * http://opalscript.org
 * Copyright 2011, Adam Beynon
 * Released under the MIT license.
 *
 * Includes Sizzle.js
 * http://sizzlejs.com/
 * Copyright 2011, The Dojo Foundation
 * Released under the MIT, BSD, and GPL Licenses.
 */
EOS

file "extras" do
  mkdir_p "extras"
end

file "extras/rquery-#{VERSION}.js" => "extras" do
  File.open("extras/rquery-#{VERSION}.js", "w+") do |file|
    file.write copyright
    file.write Opal::Gem.new(Dir.getwd).bundle
  end
end

file "extras/rquery-#{VERSION}.test.js" => "extras" do
  File.open("extras/rquery-#{VERSION}.test.js", "w+") do |file|
    file.write copyright
    file.write Opal::Gem.new(Dir.getwd).bundle :test => true
  end
end

task :clean do
  rm_rf Dir['extras/rquery*.js']
end

task :opal  => "extras/rquery-#{VERSION}.js"
task :ospec => "extras/rquery-#{VERSION}.test.js"

