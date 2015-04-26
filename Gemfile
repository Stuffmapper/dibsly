source 'https://rubygems.org'
ruby "2.2.0"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'mailboxer', :git => 'git://github.com/div/mailboxer.git', :branch => 'rails42-foreigner'

#http://dev.virtualearth.net/REST/v1/Locations?
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'bcrypt-ruby', :require=>'bcrypt'
gem 'recaptcha', '~> 0.3.6'
gem 'paperclip', '~> 4.2.1'
gem 'aws-sdk', '< 2.0'
gem 'kaminari'
gem 'mandrill-api'
gem 'newrelic_rpm'

#for using angular
gem 'active_model_serializers'
gem 'sass', '3.2.19' 
gem 'angular-rails-templates'


#for bower
gem 'bower-rails'

#heroku
gem "foreman"

gem 'geocoder'

# test rails admin
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

# cancan with rails admin
gem "cancan"

# devise with rails admin
gem "devise"

gem 'spring', group: :development

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
  gem "rspec-rails"
  gem 'jasmine'
  gem 'factory_girl_rails'
  gem 'teaspoon'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
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

