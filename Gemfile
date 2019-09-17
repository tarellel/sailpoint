source 'https://rubygems.org'

# Specify your gem's dependencies in sailpoint.gemspec
gemspec

group :development do
  gem 'guard', '~> 2.15.1'
  gem 'guard-rspec'               # Runs tests against your application if spec files are changed
  gem 'guard-bundler'             # Runs bundle install if anything you Gemfile is changed
  gem 'guard-rubocop', '~> 1.3.0' # Runs rubocop tests against your code as files are changed
  gem 'guard-yard'                # Used for generating new yard documentation as changes are made

  gem 'rubocop', '~> 0.74.0', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
end

group :test do
  gem 'fuubar'
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'webmock' # github: 'bblimke/webmock'
end

gem 'pry', group: [:development, :test]