source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '= 6.1.3.2'

# gem 'mysql2', '~> 0.5'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'psych', '~> 3.1'
gem 'carrierwave'
gem 'mini_magick'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'

  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rubocop-airbnb'
  gem 'bullet'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'capybara-email'
  gem 'email_spec'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'rspec_junit_formatter'
end

group :production do
  gem 'nokogiri', '~> 1.11.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#レイアウト関連
gem 'bootstrap', '~> 5.3.0'
gem 'font-awesome-rails'
gem 'font-awesome-sass'
gem 'jquery-rails'

#ログイン関連
gem 'omniauth-google-oauth2', git: 'https://github.com/zquestz/omniauth-google-oauth2.git'
gem 'omniauth'
gem 'dotenv-rails'
gem 'devise', git: 'https://github.com/heartcombo/devise.git', branch: 'main'
gem 'omniauth-rails_csrf_protection'

#deviseの日本語化
gem 'rails-i18n'
gem 'devise-i18n-views'

#住所の入力
gem 'jp_prefecture'

#Google map　API関連
gem 'geocoder'

#検索機能
gem 'ransack'
gem 'fog-aws'

gem 'rack-mini-profiler', '~> 2.0'

gem 'loofah', '~> 2.19.1'
