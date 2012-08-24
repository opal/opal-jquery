require 'bundler'
Bundler.setup

require 'opal/rake_task'

Opal::RakeTask.new do |t|
  t.name = 'opal-jquery'
  t.dependencies = %w(opal-spec)
end

desc "Run phantom tests"
task :test do
  src = %w(build/opal.js build/opal-spec.js vendor/jquery.js build/opal-jquery.js build/specs.js)
  out = 'build/phantom_runner.js'
  File.open(out, 'w+') do |o|
    src.each { |s| o.write File.read(s) }
  end

  sh "phantomjs build/phantom_runner.js"
end

task :default => :test

desc "Build all examples"
task :examples do
  Dir['examples/**/*.rb'].each do |s|
    out = s.chomp(File.extname(s)) + '.js'
    puts "#{s} => #{out}"
    File.open(out, 'w+') do |o|
      o.write Opal.parse(File.read s)
    end
  end
end