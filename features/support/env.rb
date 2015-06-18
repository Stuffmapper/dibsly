# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.
require 'simplecov'
# require 'metric_fu/metrics/rcov/simplecov_formatter'
# SimpleCov.formatter = SimpleCov::Formatter::MetricFu
SimpleCov.start 'rails'

require 'rspec/expectations'
require 'cucumber/rspec/doubles'
require 'capybara/cucumber'
require 'cucumber/rails'
require 'rack_session_access/capybara'
require 'capybara/email'
require "paperclip/matchers"
require 'vcr'
require 'database_cleaner'
require 'database_cleaner/cucumber'


Capybara.app_host = "http://localhost:7654"
Capybara.server_host = "localhost"
Capybara.server_port = "7654"
#set so that I can use an api key with google

WebMock.disable_net_connect!(allow_localhost: true)

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!

#
World(FactoryGirl::Syntax::Methods)
World(Capybara::Email::DSL)
World(Paperclip::Shoulda::Matchers)


ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
# begin
#   DatabaseCleaner.strategy = :transaction
# rescue NameError
#   raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
# end


# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:

DatabaseCleaner.strategy = :truncation



Before do
  DatabaseCleaner.start
end

After do |scenario|
  DatabaseCleaner.clean
end

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature

  # On demand: non-headless tests via Selenium/WebDriver
  # To run the scenarios in browser (default: Firefox), use the following command line:
  # IN_BROWSER=true bundle exec cucumber
  # or (to have a pause of 1 second between each step):
  # IN_BROWSER=true PAUSE=1 bundle exec cucumber


# Cucumber::Rails::Database.javascript_strategy = :transaction
