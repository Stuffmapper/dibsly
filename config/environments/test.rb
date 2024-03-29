Dibsly::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.middleware.use RackSessionAccess::Middleware

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_files = true
  config.static_cache_control = "public, max-age=3600"

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = true

  config.active_record.raise_in_transactional_callbacks = true
  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
  config.paperclip_defaults = {
  :s3_host_name => 's3-us-west-2.amazonaws.com',
  :storage => :s3,
  :s3_credentials => {
    :bucket => 'stuffmapper-dev'
    }
  }
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
  config.action_mailer.default_url_options = { host: "http://localhost:7654" }
  config.mandrill_mailer.default_url_options = { host: "http://localhost:7654" }
end
Rails.application.routes.default_url_options[:host] = "http://localhost:7654/"

ActionMailer::Base.delivery_method = :test

OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
  :provider => 'google_oauth2',
  :uid => '123545',
  :info => {:first_name => "Fake",
            :last_name => "Name",
            :email => 'fake@email.com'},
  :credentials => {:token => "12" * 40,
   :expires_at => Time.now + 2.days }

})

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
  :provider => 'facebook',
  :uid => '123545',
  :info => {:first_name => "Fake",
            :last_name => "Name",
            :email => 'fake@email.com',
            :nickname => "FakeName"},
  :credentials => {:token => "12" * 40 ,
   :expires_at => Time.now + 2.days }

})
