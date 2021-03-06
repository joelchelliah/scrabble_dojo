source 'https://rubygems.org'

ruby '2.2.1'

gem 'rails', '4.0.0'

gem 'bootstrap-sass', '2.3.2.1'
gem 'thin'
gem 'sass-rails', '4.0.0'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.0'
gem 'jquery-rails', '2.2.1'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'
gem 'jquery-ui-rails'
gem 'touchpunch-rails'

# for storing session info in activerecord
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

# for password encryption
gem 'bcrypt-ruby', '3.0.1'

# for making fake data
gem 'faker', '1.1.2'

# for pagination
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

group :development, :test do
  gem 'sqlite3', '1.3.10'
  gem 'rspec-rails', '2.13.1'
  gem 'guard-rspec', '2.5.0'

  # Spork stuff
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
end

group :test do
  gem 'selenium-webdriver', '~> 2.35.1'
  gem 'capybara', '2.1.0'

  # nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan
  gem "nyan-cat-formatter"

  # For easily making model objects
  gem 'factory_girl_rails', '4.2.1'

  # Used by guard
  gem 'growl', '1.0.3'
end

group :production do
  # Postgres database for Heroku
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
  gem 'rails_on_heroku'
end

group :doc do
  gem 'sdoc', '0.3.20', require: false
end
