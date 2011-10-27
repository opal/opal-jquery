require 'opal/bundle_task'

Opal::BundleTask.new do |t|
  t.runtime = true

  t.files = Dir['lib/**/*.rb']

  t.config :test do
    t.out = 'rquery.test.js'

    t.files = Dir['{lib,spec}/**/*.rb']

    t.gem 'opaltest', git: 'git://github.com/adambeynon/opaltest.git'

    t.main = 'opaltest/autorun'
  end
end

# VERSION = File.read("VERSION").strip

# copyright = <<-EOS
# /*!
 # * RQuery v#{VERSION}
 # * http://opalscript.org
 # * Copyright 2011, Adam Beynon
 # * Released under the MIT license.
 # *
 # * Includes Opal
 # * http://opalscript.org
 # * Copyright 2011, Adam Beynon
 # * Released under the MIT license.
 # *
 # * Includes Sizzle.js
 # * http://sizzlejs.com/
 # * Copyright 2011, The Dojo Foundation
 # * Released under the MIT, BSD, and GPL Licenses.
 # */
# EOS

