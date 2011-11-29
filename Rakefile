require 'opal/bundle_task'

Opal::BundleTask.new do |t|
  t.runtime = true

  t.files = Dir['lib/**/*.rb']

  t.config :test do
    t.out = 'rquery.test.js'
    t.files = Dir['{lib,spec}/**/*.{rb,js}']
    t.gem 'opaltest', git: 'git://github.com/adambeynon/opaltest.git'
    t.main = 'opaltest/autorun'
    t.stdlib = %w[optparse rbconfig]
  end
end

