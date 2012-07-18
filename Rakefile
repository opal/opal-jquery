require 'bundler'
Bundler.setup

require 'opal/rake_task'

Opal::RakeTask.new do |t|
  t.name = 'opal-jquery'
  t.dependencies = %w(opal-spec)
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