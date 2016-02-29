# source 'https://rubygems.org'
source 'https://ruby.taobao.org'

gem 'rails', '4.2.5'
gem 'sinatra', require: nil

gem 'redis'
gem 'mysql2'

gem 'multi_json'
gem 'oj'
gem "paranoia", "~> 2.0"

gem 'mine_setting'

gem 'sidekiq', '~> 4.0.1'
gem 'sidekiq-cron', '~> 0.4.2'

gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'jquery-rails'
gem 'turbolinks'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'

gem 'slim-rails'
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# gem 'omniauth', '~> 1.3.1'

gem 'puma'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'

  gem 'rspec-rails'

  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'


  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'capistrano-rvm'
end

group :test do
  gem 'database_cleaner'
end

