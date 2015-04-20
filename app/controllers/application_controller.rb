class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_filter :authentication_check

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
   def authentication_check
      authenticate_or_request_with_http_basic do |username, password|
        username == "startup" && password == "weekend" || username == "stuff" && password == "testitall" || username == "stuff" && password == "letstest"
      end
    end

end

 

