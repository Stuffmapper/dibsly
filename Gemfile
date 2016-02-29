source 'https://rubygems.org'
ruby "2.2.4"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2', '>= 4.2.5.1'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'


# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

#for emailing
gem 'mandrill-api', '~> 1.0', '>= 1.0.53'
gem 'mandrill_mailer', '~> 1.2.0'

#http://dev.virtualearth.net/REST/v1/Locations?
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'bcrypt-ruby', '~> 3.1.5'
gem 'recaptcha', '~> 0.3.6'
gem 'paperclip', '~> 4.2.1'
gem 'aws-sdk', '< 2.0'
gem 'kaminari'

gem 'bootstrap-sass'
gem 'autoprefixer-rails'

#for using angular
gem 'active_model_serializers'
gem 'angular-rails-templates'

# for FB
gem 'omniauth-facebook', '~> 3.0'

#for google
gem 'omniauth-google-oauth2', '~> 0.3.0'


#for Auth
gem 'jwt', '~> 1.5.1'

#for bower
gem 'bower-rails'

#heroku
gem "foreman"

gem 'geocoder'


gem 'delayed_paperclip'

gem 'delayed_job_active_record'



group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


group :production, :staging do
  gem "rails_12factor"
  gem "rails_stdout_logging"
  gem "rails_serve_static_assets"
end



group :development, :test do
  gem 'timecop', '~> 0.7.3'
  gem "rspec-rails"
  gem 'jasmine'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'factory_girl_rails'
  gem 'teaspoon', '~> 1.1', '>= 1.1.4'
  gem 'teaspoon-jasmine'
  gem 'cucumber-rails', require: false
  gem 'rack_session_access'
  gem 'guard-rspec', require: false
  gem 'guard-cucumber'
  gem 'guard-rails'
  gem "guard-teaspoon"
  # Use a debugger
  gem 'pry-byebug'
  gem 'metric_fu'

end

group :test do
  gem 'capybara', '~> 2.4.4'
  gem 'capybara-email'
  gem 'shoulda-matchers','~> 2.4.0'
  gem 'vcr'
  gem 'simplecov', :require => false
  gem "selenium-webdriver"
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'launchy'
  gem 'capybara-angular'
  gem 'webmock'
end
