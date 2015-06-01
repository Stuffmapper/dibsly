class PostsController < ApplicationController
 

  # GET /posts
  # GET /posts.json

  def index
    user_ip = request.location
    
    if user_ip && !user_ip.longitude == 0.0
      @map = user_ip.longitude.to_s + ', ' + user_ip.latitude.to_s
    else
      @map = '47.6097,-122.3331'
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if (current_user) and @post.creator_id == current_user.id
        cleaned_params = post_params.delete_if{
          |key, value| value == 'undefined'  
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
          |key, value| value == 'undefined'  
      }
      @user = User.find( current_user.id )
      @post = Post.new(cleaned_params.merge(
          :ip => request.remote_ip, 
          :status => 'new', 
          :creator_id => @user.id ))
      if @post.valid?
        @post.save
        render json: '[]', status: :ok
      else
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
    #TODO - change available_to_dib as part of the scope
    @posts = @posts.select{ |post| post.available_to_dib? }
    
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
      @posts = Post.where("creator_id = ? 
                   OR dibber_id = ?", 
                 current_user.id.to_s,
                 current_user.id.to_s )
      @dibs = current_user.dibs
   

      #@posts = Post.where(:creator_id => current_user.id ).or(Post.where(:dibber_id => current_user.id ))
      render json:  @posts, status: :ok
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
      params.permit(:image,:category, :latitude, :longitude, :description, :published, :on_the_curb )
    end


end
