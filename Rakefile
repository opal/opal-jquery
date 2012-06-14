require 'bundler'
Bundler.setup

require 'opal'

Opal::BuilderTask.new do |t|
  t.name = 'opal-dom'
  t.dependencies = ['opal-spec']
end

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