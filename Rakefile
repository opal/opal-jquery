require 'bundler'
Bundler.require
Bundler::GemHelper.install_tasks

ENV['RUNNER'] ||= 'chrome'

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:default) do |server, task|
  server.index_path = 'spec-opal/jquery/index.html.erb'
  task.default_path = 'spec-opal'
end

Opal::RSpec::RakeTask.new(:jquery3) do |server, task|
  server.index_path = 'spec-opal/jquery/index3.html.erb'
  task.default_path = 'spec-opal'
end

desc "Build build/opal-jquery.js"
task :dist do
  require 'fileutils'
  FileUtils.mkdir_p 'build'

  src = Opal::Builder.build('opal-jquery')
  min = uglify src
  gzp = gzip min

  File.open('build/opal-jquery.js', 'w+') do |out|
    out << src
  end

  puts "development: #{src.size}, minified: #{min.size}, gzipped: #{gzp.size}"
end

# Used for uglifying source to minify
def uglify(str)
  IO.popen('uglifyjs', 'r+') do |i|
    i.puts str
    i.close_write
    return i.read
  end
rescue Errno::ENOENT
  $stderr.puts '"uglifyjs" command not found (install with: "npm install -g uglify-js")'
  nil
end

# Gzip code to check file size
def gzip(str)
  IO.popen('gzip -f', 'r+') do |i|
    i.puts str
    i.close_write
    return i.read
  end
rescue Errno::ENOENT
  $stderr.puts '"gzip" command not found, it is required to produce the .gz version'
  nil
end


namespace :doc do
  doc_repo = Pathname(ENV['DOC_REPO'] || 'gh-pages')
  doc_base = doc_repo.join('doc')
  current_git_release = -> { `git rev-parse --abbrev-ref HEAD`.chomp }
  # template_option = "--template opal --template-path #{doc_repo.join('yard-templates')}"
  template_option = ""

  directory doc_repo.to_s do
    remote = ENV['DOC_REPO_REMOTE'] || '.'
    sh 'git', 'clone', '-b', 'gh-pages', '--', remote, doc_repo.to_s
  end

  # To generate docs that live on http://opalrb.org/opal-jquery/ use the
  # `rake doc` task
  #
  # DOC_REPO_REMOTE=https://github.com/opal/opal-jquery.git bundle exec rake doc
  # open gh-pages/index.html
  task :default => doc_repo.to_s do
    git  = current_git_release.call
    name = 'api'
    glob = 'opal/**/*.rb'
    command = "yard doc #{glob} #{template_option} "\
              "--readme opal/README.md -o gh-pages/doc/#{git}/#{name}"
    puts command; system command
  end

  # To generate api docs on rubygems: http://www.rubydoc.info/gems/opal-jquery/0.4.2
  # yard --main README.md --markup markdown --github
  # open doc/index.html
end

task :doc => 'doc:default'
