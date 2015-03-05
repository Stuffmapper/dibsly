class SessionsController < ApplicationController
  def create
    
    user = User.authenticate(params[:username], params[:password])

      if user
        session[:user_id] = user.id
        session[:latitude] = user.latitude
        session[:longitude] = user.longitude
        session[:zoom] = user.zoom
        session[:grid_mode] = user.grid_mode
        render json: '[]', status: :ok
      else
        
        render json: '[]', status: :unprocessable_entity
      end
  end

  def destroy
    session[:user_id] = nil
    session[:latitude] = nil
    session[:longitude] = nil
    session[:zoom] = nil
    session[:grid_mode] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

  def check
    if current_user
      
      render json: '{message: User is logged in }', status: :ok
    else
      render json: '{error: User not logged in }', status: :unauthorized
    end

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def sessions_params
      params.permit(:username, :password)
    end
end

