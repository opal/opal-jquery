require 'bundler/setup'
require 'opal/rake_task'

Opal::RakeTask.new do |t|
  t.name = 'opal-jquery'
  t.dependencies = ['opal-spec']
end

task :default => :'opal:test'

namespace :docs do
  desc "Build docs"
  task :build do
    require 'redcarpet'
    require 'albino'

    klass = Class.new(Redcarpet::Render::HTML) do
      def block_code(code, language)
        Albino.new(code, language || :text).colorize
      end
    end

    markdown = Redcarpet::Markdown.new(klass, :fenced_code_blocks => true)

    File.open('gh-pages/index.html', 'w+') do |o|
      puts " * index.html"
      # remove first 2 lines (header/build status), as pre.html has a docs version
      src = File.read("README.md").sub(/^(?:[^\n]*\n){4}/, '')

      o.write File.read('docs/pre.html')
      o.write markdown.render(src)
      o.write File.read('docs/post.html')
    end
  end

  desc "Clone repo"
  task :clone do
    if File.exists? 'gh-pages'
     Dir.chdir('gh-pages') { sh 'git pull origin gh-pages' }
    else
      FileUtils.mkdir_p 'gh-pages'
      Dir.chdir('gh-pages') do
        sh 'git clone git@github.com:/opal/opal-jquery.git .'
        sh 'git checkout gh-pages'
      end
    end
  end

  desc "commit and push"
  task :push do
    Dir.chdir('gh-pages') do
      sh "git add ."
      sh "git commit -a -m \"Documentation update #{Time.new}\""
      sh "git push origin gh-pages"
    end
  end
end