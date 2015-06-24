class SessionsController < ApplicationController
  def create
    username = params[:username]
    user = User.find_by_username(username) || User.find_by_email(username.downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: {user:user.username}, status: :ok
    else
      render json: '[]', status: :unprocessable_entity
    end
  end

  def create_with_omniauth
    user = User.from_omniauth(env["omniauth.auth"],request)
    if user
      session[:user_id] = user.id
      redirect_to '/'
    end
  end



  def destroy
    session[:user_id] = nil
    session[:latitude] = nil
    session[:longitude] = nil
    session[:zoom] = nil
    session[:grid_mode] = nil
    render json: '[]', status: :ok
  end

  def check
    if current_user

      render json: {
          message: 'User is logged in',
          user: current_user.username },
          status: :ok
    else
      render json: {
          message: 'User not logged in' },
          status: :unauthorized
    end
  end

  private
    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def sessions_params
      params.permit(:username, :password)
    end
end
