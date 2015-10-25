class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :current_user
  helper_method :admin
  skip_before_action :verify_authenticity_token, if: :json_request?

  private

  #to use the admin
  def admin
    user = session[:user_id] && User.find(session[:user_id])
    @current_user =  user ? user.admin : false
  end

  def current_user
    @current_user = decoded_auth_token ? User.find(decoded_auth_token[0]["user_id"]) : false
  end

  def json_request?
    request.format.json?
  end


  def decoded_auth_token
    begin
      AuthToken.valid? http_auth_header_content
    rescue
      false
    end
  end
  # JWT's are stored in the Authorization header using this format:
  # Bearer somerandomstring.encoded-payload.anotherrandomstring
  def http_auth_header_content
    return @http_auth_header_content if defined? @http_auth_header_content
    @http_auth_header_content = begin
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      else
        nil
      end
    end
  end
  def serialization_scope
    { :current_user => current_user }
  end
end
