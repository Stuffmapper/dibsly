source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

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


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'


#for using angular
gem 'active_model_serializers'
gem 'sass', '3.2.19' 

#for bower
gem 'bower-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
#gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development



# Use debugger
gem 'debugger', group: [:development, :test]

#for heroku
gem "foreman"

gem 'rails_12factor', group: :production
gem 'bcrypt-ruby', :require=>'bcrypt'
gem 'recaptcha', '~> 0.3.6'
gem 'paperclip', '~> 3.4'
gem 'aws-sdk'
gem 'kaminari'
gem 'mandrill-api'
gem 'newrelic_rpm'

#gem 'geocoder'

group :development do
  gem 'guard-rspec', require: false
 

end
group :development, :test do
  gem "rspec-rails", "~> 2.0"
  gem 'jasmine'
  gem 'factory_girl_rails'
end



group :test do
  gem 'capybara', '~> 2.4.4'
  gem 'shoulda-matchers','~> 2.4.0'
  gem 'vcr'
  gem 'simplecov', :require => false
  gem "selenium-webdriver"
end

