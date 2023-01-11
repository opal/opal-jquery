source 'https://rubygems.org'
gemspec

gem 'c_lexer', platform: :mri

case (opal_version = ENV['OPAL_VERSION']) || 'master'
when 'master'
  gem 'opal', github: 'opal/opal', branch: 'master'
  gem 'opal-sprockets', github: 'opal/opal-sprockets'
  gem 'opal-rspec', github: 'opal/opal-rspec', branch: 'master', submodules: true
when nil
  gem 'opal' # let bundler pick a version
else
  gem 'opal', opal_version
end

# gem 'opal-rspec', github: 'opal/opal-rspec', submodules: true
# gem 'opal-rspec', path: '../opal-rspec'
gem 'rack', ENV['RACK_VERSION'] || '> 0'
