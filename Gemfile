source 'http://rubygems.org'

gem 'rails', '3.2.3'

gem 'twitter-bootstrap-rails'

gem 'jquery-rails'
gem 'gravatar_image_tag'
gem 'bootstrap-will_paginate'

gem 'parseconfig'
gem 'encryptor'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  #gem 'therubyracer'
end

group :production, :staging do
  gem 'pg'
end

group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'heroku'
end

group :test do
  gem 'webrat', '~> 0.7'
  gem 'factory_girl_rails', '1.0'
end

group :development, :test do
  gem 'sqlite3', '~> 1.3.6'
  gem 'rspec-rails', '~> 2.6'
end