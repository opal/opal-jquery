require 'bundler/setup'
require 'fileutils'
require 'opal'

desc "Build opal runtime, dependencies and opal-jquery"
task :opal do
  build_to 'opal',        Opal.runtime
  build_to 'opal-spec',   Opal.build_gem('opal-spec')
  build_to 'opal-jquery', Opal.build_files('lib')
  build_to 'specs',       Opal.build_files('spec')
end

def build_to(name, code)
  FileUtils.mkdir_p 'build'
  puts " * build/#{name}.js"
  File.open("build/#{name}.js", 'w+') { |o| o.puts code }
end

task :test do
  sh "phantomjs vendor/phantom_runner.js spec/index.html"
end

task :default => :test