class Api::PostsController < ApplicationController
  require 'auth_token'
  before_action :authorize, only: [:create, :remove, :update, :my_stuff, :my_dibs]
  before_action :find_my_post, only: [:remove, :update]

  # GET /posts
  # GET /posts.json


  def create
    cleaned_params = post_params.delete_if{
      |key, value| value == 'undefined' || value == 'null' || key == 'image'
    }
    params = cleaned_params.merge(
        :ip => request.remote_ip,
        :status => 'loading',
        :user => current_user,
        :creator_id => current_user.id )
    @post = Post.new(params)
    if @post.valid? 
      @post.save
      render json: @post, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  #temp removed where(status: 'new');
  def geolocated
    @posts = Post.where(:latitude => params[:seLat]..params[:nwLat])
                 .where(:longitude => params[:nwLng]..params[:seLng])
                 .where(:published => true)
                 .where("dibbed_until < ?", Time.now)
    render json: @posts
  end

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

  # GET /posts/my_stuff
  def my_stuff
    @posts = Post.where(:user => current_user)
    render json:  @posts, each_serializer: PostSerializer, status: :ok
  end

  def my_dibs
    @dibs = current_user.dib_posts
    render json:  @dibs, each_serializer: PostSerializer, status: :ok
  end

  #POST /posts/:id/remove
  def remove 
    @post.update_attribute(:status, 'deleted')
    render json: '[]', status: :ok
  end

    # GET /posts/search
  def search
    #FIXME. Not used this way anymore
    @posts = Post.near([ params[:latitude],params[:longitude]], 10)
    if params[:on_the_curb] != nil
      @posts =  @posts.where(:on_the_curb => params[:on_the_curb])
    end
    @posts = @posts.select{ |post| post.available_to_dib? }
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def update
    cleaned_params = post_params.delete_if{
      |key, value| value == 'undefined' || value == 'null'
    }
    @post.update_attributes cleaned_params
    render json: '[]', status: :ok
  end

  private

  def post_params
    params.permit(:image,:category, :latitude, :longitude, :description,
      :published, :on_the_curb, :status )
  end

  def authorize
    render json: {message: 'User not logged in' }, 
    status: :unauthorized unless current_user
  end

  def find_my_post
    @post = Post.find(params[:id])
    render json: {error: 'not authorized '}, status: :unauthorized unless ( 
    current_user and  current_user == @post.creator )
  end

end
