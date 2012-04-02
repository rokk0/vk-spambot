source 'http://rubygems.org'

gem 'rails', '3.2.1'
gem 'jquery-rails', '>= 1.0.12'
gem 'sqlite3', '1.3.5'
gem 'gravatar_image_tag'
gem 'will_paginate'

gem 'parseconfig'
gem 'mechanize'
gem 'openwferu-scheduler'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  #gem 'therubyracer'  
end

group :production, :staging do
  gem "pg"
end

group :development do
  gem 'rspec-rails', '~> 2.6'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end

group :test do
  gem 'rspec-rails', '~> 2.6'
  gem 'webrat', '~> 0.7'
  gem 'factory_girl_rails', '1.0'
end

group :development, :test do
  gem "sqlite3-ruby", "~> 1.3.3", :require => "sqlite3"
end