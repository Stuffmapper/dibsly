class Api::PostsController < ApplicationController
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

  def update
    @post = Post.find(params[:id])
    if (current_user) and @post.creator_id == current_user.id
        cleaned_params = post_params.delete_if{
          |key, value| value == 'undefined' || value == 'null'
      }
      @post.update_attributes cleaned_params
      @post.save!
      render json: '[]', status: :ok
    else
      render json: {error: 'not authorized '}, status: :unauthorized
    end
  end

  def create
    if (current_user)
      cleaned_params = post_params.delete_if{
          |key, value| value == 'undefined' || value == 'null' || key == 'image'
      }
      params = cleaned_params.merge(
          :ip => request.remote_ip,
          :status => 'new',
          :user => current_user,
          :creator_id => current_user.id )
      @post = Post.new(params)

      if @post.valid? and ( post_params['image'] || post_params['image'] != 'null' || post_params['image'] != 'undefined')
        @post.save
        UploadImageJob.perform_later( @post, post_params['image'] )
        render json: @post , status: :ok
      else
        if ( !post_params['image'] || post_params['image'] == 'null' || post_params['image'] == 'undefined')
          @post.errors.add(:image, "can't be blank")
        end
        render json: @post.errors, status: :unprocessable_entity
      end
    else
      render json: {error: 'not authorized '}, status: :unauthorized
    end
  end

  # POST /posts/dib/1
  # POST /posts/dib/1.json
  def dib
    if current_user && dib_params[:id]

      @post = Post.find(dib_params[:id])

      if @post.available_to_dib?
         @post.create_new_dib(current_user)
         add_dib(@post, request, current_user)
         render json: '[]', status: :ok
      end
    else
      render json: '[]', status: :unprocessable_entity
    end
  end

  # POST /posts/claim/1
  # POST /posts/claim/1.json

  def geolocated

    @posts = Post.where(:latitude => params[:swLat]..params[:neLat])
                 .where(:longitude => params[:swLng]..params[:neLng])
                 .where(:published => true)
                 .where(:status => 'new')
                 .where("dibbed_until < ?", Time.now)

    render json: @posts
  end



  # GET /posts/search
  def search
    @posts = Post.near([ params[:latitude],params[:longitude]], 10)
    if params[:on_the_curb] != nil
      @posts =  @posts.where(:on_the_curb => params[:on_the_curb])
    end
    @posts = @posts.select{ |post| post.available_to_dib? }
    render json: @posts
  end

  # GET /posts/my_stuff
  def my_stuff
    if (current_user)
      @posts = Post.where(:user =>
                 current_user)


      render json:  @posts, each_serializer: MyPostSerializer, status: :ok
    else
      render json: {message: 'User not logged in' }, status: :unauthorized
    end
  end

  def my_dibs
    if (current_user)

      @dibs = current_user.dib_posts

      render json:  @dibs, each_serializer: MyPostSerializer, status: :ok
    else
      render json: {message: 'User not logged in' }, status: :unauthorized
    end
  end

  def show
    @post = Post.find(params[:id])
   render json: @post

  end

  private

    def post_params
      params.permit(:image,:category, :latitude, :longitude, :description, :published, :on_the_curb, :status )
    end


end
