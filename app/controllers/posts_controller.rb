class PostsController < ApplicationController
  before_action :set_post, only: [:show, :dib]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.page(params[:page]).per(5)
    if (current_user)
      @post = Post.new(:on_the_curb => 1)
    else
      @user = User.new
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  #def show
  #end

  # GET /posts/new
  #def new
  #  if (current_user)
  #    @post = Post.new
  #  else
  #    redirect_to action: "index"
  #  end
  #end

  # POST /posts
  # POST /posts.json
  def create
    if (current_user)
      @user = User.find(session[:user_id])
      @post = Post.new(post_params.merge(:ip => request.remote_ip, :status => 'new', :creator_id => session[:user_id]))

      respond_to do |format|
        if @post.save
          format.json {render json: '[]', status: :ok}
        else
          format.json {render json: @post.errors, status: :unprocessable_entity}
        end
      end
    end
  end
  
  # POST /posts/dib/1
  # POST /posts/dib/1.json
  def dib
    if (current_user) && (@post.status == 'new') && ((@post.dibbed_until == nil) || (@post.dibbed_until < Time.now))
      # 60 seconds
      @post.dibbed_until = Time.now + Dib.timeSpan
      @post.update(params[:dibbed_until])
      
      @dib = @post.dibs.build
      @dib.ip = request.remote_ip
      @dib.valid_until = @post.dibbed_until
      @dib.status = 'new'
      @dib.creator_id = session[:user_id]
      @dib.save
    else
      flash[:error] = 'Post not available'
    end
    
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  # POST /posts/geolocated.json
  def geolocated
    @posts = Post.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ? AND title ILIKE ?", params[:neLat], params[:swLat], params[:neLng], params[:swLng], "%#{params[:term]}%").limit(50)
    @posts.each do |post|
      post.image_url = post.image.url(:medium)
    end
    @term = params[:term]
    render json: @posts
  end

  # GET /posts/search
  def search
    @posts = Post.where("title ILIKE ?", "%#{params[:term]}%").page(params[:page]).per(5)
    @term = params[:term]
    if (current_user)
      @post = Post.new
    end
    render action: 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :image_url, :latitude, :longitude, :address, :on_the_curb, :phone_number, :status, :ip, :dibbed_until, :creator_id, :image)
    end
end
