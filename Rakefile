require 'opal'

VERSION = File.read("VERSION").strip

copyright = <<-EOS
/*!
 * Vienna v#{VERSION}
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

file "extras/vienna-#{VERSION}.js" => "extras" do
  File.open("extras/vienna-#{VERSION}.js", "w+") do |file|
    file.write copyright
    file.write Opal::Gem.new(Dir.getwd).bundle
  end
end

task :opal => "extras/vienna-#{VERSION}.js"

