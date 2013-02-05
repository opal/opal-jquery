require 'bundler/setup'
require 'opal-jquery'
require 'opal-spec'

desc "Build opal-jquery into build"
task :build do
  File.open('build/opal-jquery.js', 'w+') do |out|
    out.puts Opal.process('opal-jquery')
  end
end

desc "Build example specs ready to run"
task :build_specs do
  Opal.append_path File.join(File.dirname(__FILE__), 'spec')

  File.open('build/specs.js', 'w+') do |out|
    out.puts Opal.process('spec_helper')
  end
end
