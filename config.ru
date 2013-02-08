require 'bundler'
Bundler.require

html = <<-HTML
  <!DOCTYPE html>
  <html>
  <head>
    <title>opal-jquery specs</title>
  </head>
    <body>
      <script src="/assets/autorun.js"></script>
    </body>
  </html>
HTML

map '/assets' do
  env = Opal::Environment.new
  env.append_path 'vendor' # for jquery
  env.append_path 'spec'
  run env
end

map '/' do
  run lambda { |env|
    if env['PATH_INFO'] == '/'
      [200, {'Content-Type' => 'text/html'}, [html]]
    else
      Rack::Directory.new('spec').call(env)
    end
  }
end
