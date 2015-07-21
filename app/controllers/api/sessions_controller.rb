class Api::SessionsController < ApplicationController
  require 'auth_token'
  def create
    username = params[:username] ? params[:username] : ''
    user = User.where("lower(username) = ?",
    username.downcase ).first  || User.find_by_email(username.downcase)
    if user && user.authenticate(params[:password])
      token = AuthToken.issue_token({ user_id: user.id })
      render json: {user: user.username,
        user_id: user.id,
        token: token}, status: :ok
    else
      render json: '[]', status: :unprocessable_entity
    end
  end

  def create_with_omniauth
    user = User.from_omniauth(env["omniauth.auth"],request)
    if user
      #render jwt
      token = AuthToken.issue_token :user_id => user.id,
        :exp => 2.weeks.from_now.to_i
      session[:user_id] = user.id
      session[:auth] = 'social'
      redirect_to '/'
    end
  end



  def destroy
    session[:user_id] = nil
    render json: '[]', status: :ok
  end

  def check
    token = params[:token]
    if AuthToken.valid? token
      head 200
    else
      head 401
    end
  end

    #check token


  private
    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def sessions_params
      params.permit(:username, :password)
    end
end
