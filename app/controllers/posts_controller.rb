class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :dib]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.page(params[:page]).per(5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    if (current_user)
      @post = Post.new
    else
      redirect_to action: "index"
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    if (current_user)
      @user = User.find(session[:user_id])
      @post = Post.new(post_params.merge(:ip => request.remote_ip, :status => 'new', :creator_id => session[:user_id], :latitude => @user.latitude, :longitude => @user.longitude, :address => @user.address))

      respond_to do |format|
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render action: 'show', status: :created, location: @post }
        else
          format.html { render action: 'new' }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
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
    @term = params[:term]
    render json: @posts
  end

  # GET /posts/search
  def search
    @posts = Post.where("title ILIKE ?", "%#{params[:term]}%").page(params[:page]).per(5)
    @term = params[:term]
    render action: 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :image_url, :latitude, :longitude, :status, :ip, :dibbed_until, :creator_id, :image)
    end
end
