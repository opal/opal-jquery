require 'bundler'
Bundler.setup

require 'opal/rake_task'

Opal::RakeTask.new do |t|
  t.name         = 'oquery'
  t.parser       = true # opal-parser for examples
  t.dependencies = %w(ospec)
end

desc "Run phantom tests"
task :test do
  src = %w(build/opal.js build/ospec.js vendor/jquery.js build/oquery.js build/specs.js)
  out = 'build/phantom_runner.js'
  File.open(out, 'w+') do |o|
    src.each { |s| o.write File.read(s) }
  end

  sh "phantomjs build/phantom_runner.js"
end

task :default => :test