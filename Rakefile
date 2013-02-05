require 'bundler'
Bundler.require

desc "Build opal-jquery into build"
task :build => [:dir] do
  File.open('build/opal-jquery.js', 'w+') do |out|
    out.puts Opal.process('opal-jquery')
  end
end

desc "Build example specs ready to run"
task :build_specs => [:dir] do
  Opal.append_path File.join(File.dirname(__FILE__), 'spec')

  File.open('build/specs.js', 'w+') do |out|
    out.puts Opal.process('spec_helper')
  end
end

task :dir do
  FileUtils.mkdir_p 'build'
end

task :test do
  OpalSpec.runner
end

task :default => [:build_specs, :test]
