require 'bundler/setup'
require 'opal/rake_task'

Opal::RakeTask.new do |t|
  t.name         = 'opal-jquery'
  t.dependencies = %w(opal-spec)
end

task :default => 'opal:test'