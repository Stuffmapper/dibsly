class SessionsController < ApplicationController
  def create

    user = User.authenticate((params[:username], params[:password]) 
    
      if user
        session[:user_id] = user.id
        session[:latitude] = user.latitude
        session[:longitude] = user.longitude
        session[:zoom] = user.zoom
        session[:grid_mode] = user.grid_mode
        render json: {user:user.username}, status: :ok
      else
        render json: '[]', status: :unprocessable_entity
      end
  end

  def create_with_omniauth
    user = User.from_omniauth(env["omniauth.auth"])
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

