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
    o.write File.read('src/pre.html')
    o.write markdown.render(File.read "src/index.md")
    o.write File.read('src/post.html')
  end
end

task :default => :build