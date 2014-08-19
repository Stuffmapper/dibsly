class PostsController < ApplicationController
  before_action :set_post, only: [:show, :dib]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where("status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()))", 'new').page(params[:page]).per(6)
    if (current_user)
      @post = Post.new(:on_the_curb => 1, :phone_number => current_user.phone_number)
      @message = Message.new()
    else
      @user = User.new
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    if (current_user)
      @user = User.find(session[:user_id])

      data = nil
      if post_params[:image_url] && !post_params[:image_url].blank?
        urlSegments = post_params[:image_url].match(/data:(.*);base64,(.*)/)
        data = StringIO.new(Base64.decode64(urlSegments[2]))
        data.class.class_eval {attr_accessor :original_filename, :content_type}
        data.original_filename = 'file'
        data.content_type = urlSegments[0]
      end

      post_params.delete :image_url

      @post = Post.new(post_params.merge(:ip => request.remote_ip, :status => 'new', :creator_id => session[:user_id]))
      @post.image_url = nil
      @post.image = data

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
    if (current_user) && (@post.status == 'new') && ((@post.dibbed_until == nil) || (@post.dibbed_until <= Time.now))
      # 3600 seconds = 1 hour
      @post.dibbed_until = Time.now + Dib.timeSpan
      @post.status == 'dibbed'
      @post.dibber_id = session[:user_id]
      @post.save
      
      @dib = @post.dibs.build
      @dib.ip = request.remote_ip
      @dib.valid_until = @post.dibbed_until
      @dib.status = 'new'
      @dib.creator_id = session[:user_id]
      @dib.save

      @message = Message.new()
      @message.sender_id = session[:user_id]
      @message.sender_name = User.find(session[:user_id]).name
      @message.receiver_id = @post.creator_id
      @message.receiver_name = User.find(@post.creator_id).name
      @message.content = 'I just dibbed your item'
      @message.status = 'new'
      @message.ip = request.remote_ip
      @message.save
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
    @posts = Post.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ? AND title ILIKE ? AND status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()))", params[:neLat], params[:swLat], params[:neLng], params[:swLng], "%#{params[:term]}%", 'new').limit(50)
    @posts.each do |post|
      post.image_url = post.image.url(:medium)
    end
    @term = params[:term]
    render json: @posts

    session[:latitude] = params[:swLat].to_f + ((params[:neLat].to_f - params[:swLat].to_f)/2)
    session[:longitude] = params[:swLng].to_f + ((params[:neLng].to_f - params[:swLng].to_f)/2)
    session[:zoom] = params[:zoom]
    if (current_user)
      current_user.latitude = session[:latitude]
      current_user.longitude = session[:longitude]
      current_user.zoom = params[:zoom]
      current_user.save
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :image_url, :latitude, :longitude, :zoom, :address, :grid_mode, :phone_number, :image, :on_the_curb)
    end
end
