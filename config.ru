require 'bundler'
Bundler.require

map '/assets' do
  env = Opal::Environment.new
  env.append_path 'spec'
  run env
end

run Rack::Directory.new('spec')
