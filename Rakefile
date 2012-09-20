require 'bundler'
Bundler.setup

require 'redcarpet'
require 'albino'

desc "Build docs"
task :build do
  klass = Class.new(Redcarpet::Render::HTML) do
    def block_code(code, language)
      Albino.new(code, language || :text).colorize
    end
  end

  markdown = Redcarpet::Markdown.new(klass, :fenced_code_blocks => true)

  File.open('index.html', 'w+') do |o|
    puts " * index.html"
    # remove first 2 lines (header/build status), as pre.html has a docs version
    src = File.read("../README.md").sub(/^(?:[^\n]*\n){4}/, '')

    o.write File.read('src/pre.html')
    o.write markdown.render(src)
    o.write File.read('src/post.html')
  end
end

task :default => :build