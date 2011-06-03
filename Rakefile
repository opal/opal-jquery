require 'opal'
require 'fileutils'

COPYRIGHT = <<-EOS
/*!
 * RQuery DOM library for opal
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

desc "Rebuild rquery.js ready for browser"
task :opal do
  FileUtils.mkdir_p 'extras'

  gem = Opal::Gem.new File.dirname(__FILE__)
  content = gem.bundle :standalone => true
  content = COPYRIGHT + content

  File.open('extras/rquery.js', 'w+') { |out| out.write content }
end


desc "Build ospec package into extras/rquery.spec.js ready for browser tests"
task :ospec do
  FileUtils.mkdir_p 'extras'

  gem = Opal::Gem.new File.dirname(__FILE__)
  content = gem.bundle :dependencies => 'ospec', :main => 'ospec/autorun', :test_files => true
  File.open('extras/rquery.spec.js', 'w+') { |out| out.write content }
end

