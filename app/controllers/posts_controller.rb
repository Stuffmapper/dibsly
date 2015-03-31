class PostsController < ApplicationController
 
  before_action :set_post, only: [:show, :claim]
        #this should be part of the model _ on save

  # GET /posts
  # GET /posts.json

  def index
    user_ip = request.location
    
    if !user_ip.longitude == 0.0
      @map_center = {'latitude'=> user_ip.latitude, 'longitude'=> user_ip.longitude }.to_json
    else
    @map_center = {'latitude'=> 47.6097, 'longitude'=> -122.3331 }.to_json
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    if (current_user)
      cleaned_params = post_params.delete_if{ |key, value| value == 'undefined'  }
      @user = User.find( current_user.id )
      @post = Post.new(cleaned_params.merge(:ip => request.remote_ip, :status => 'new', :creator_id => @user.id ))
      if @post.save
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
    render json: @posts
  end

  # POST /posts/grid_mode.json
  def grid_mode
    session[:grid_mode] = params[:grid_mode]
    if (current_user)
      current_user.grid_mode = session[:grid_mode]
      current_user.save
    end
    respond_to do |format|
        format.json {render json: '[]', status: :ok}
    end
  end

  # GET /posts/search
  def search
    @posts = Post.where("title ILIKE ? AND status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()))", "%#{params[:term]}%", 'new').page(params[:page]).per(6)
    @term = params[:term]
    if (current_user)
      @post = Post.new(:on_the_curb => 1, :phone_number => current_user.phone_number)
      @message = Message.new()
    else
      @user = User.new
    end
    render action: 'index'
  end

  # GET /posts/my_stuff
  def my_stuff
    if (current_user)
      @posts = Post.where(:creator_id => current_user.id )
      render json: @posts
    else
      render json: {message: 'User not logged in' }, status: :unauthorized
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.permit(:image,:category, :latitude, :longitude)
    end
    def dib_params
      params.permit(:id)
    end

    def add_dib (post, request, current_user)
      @dib = post.dibs.build
      @dib.ip = request.remote_ip
      @dib.valid_until = post.dibbed_until
      @dib.status = 'new'
      @dib.creator_id = current_user.id 
      @dib.save
    end


end
