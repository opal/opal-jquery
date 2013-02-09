require 'bundler'
Bundler.require

require 'opal/spec/rake_task'
Opal::Spec::RakeTask.new do |t|
  t.port = 9999
  t.url_path = "http://localhost:9999/index.html"
end

task :default => 'opal:spec'
