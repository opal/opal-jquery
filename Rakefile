require 'bundler'
Bundler.setup

require 'opal'

Opal::BuilderTask.new do |t|
  t.name = 'rquery'
  t.dependencies = ['opal-spec']
  t.main = 'rquery'
  t.specs_main = 'opal-spec/autorun'
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