require 'bundler'
Bundler.setup

require 'opal/rake_task'

Opal::RakeTask.new do |t|
  t.name         = 'opal-jquery'
  # t.parser       = true # opal-parser for examples
  t.dependencies = %w(opal-spec)
end

desc "Run phantom tests"
task :test do
  sh "phantomjs vendor/opal_spec_runner.js spec/index.html"
end

task :default => :test