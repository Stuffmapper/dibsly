class PostsController < ApplicationController
  require 'auth_token'

  # GET /posts
  # GET /posts.json

  def index
    user_ip = request.location

    if user_ip && !user_ip.longitude == 0.0
      @map = user_ip.longitude.to_s + ', ' + user_ip.latitude.to_s
    else
      @map = '47.6097,-122.3331'
    end
    if session[:auth] == 'social' and session[:user_id]
      current_user = User.find(session[:user_id])
      token = AuthToken.issue_token :user_id => current_user.id,
        :exp => 2.weeks.from_now.to_i
      @omniuser = {user:current_user.username,
        token: token,
        user_id: current_user.id}
        session[:auth] == nil
    end
  end


end
