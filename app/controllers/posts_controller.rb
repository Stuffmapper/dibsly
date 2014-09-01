class PostsController < ApplicationController
  before_action :set_post, only: [:show, :dib]

  http_basic_authenticate_with :name => "startup", :password => "weekend"

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where("status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()) OR creator_id = ?)", 'new', session[:user_id]).page(params[:page]).per(6)
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

      # message to poster
      @message = Message.new()
      @message.sender_id = session[:user_id]
      @message.sender_name = User.find(session[:user_id]).name
      @message.receiver_id = @post.creator_id
      @message.receiver_name = User.find(@post.creator_id).name
      if (@post.on_the_curb)
        @message.content = 'Greetings. I just dibbed your stuff, I\'ll pick it up soon :)'
      else
        @message.content = 'Greetings. I just dibbed your st6uff, can you tell me when can I go to pick it up? :)'
      end
      @message.status = 'new'
      @message.ip = request.remote_ip
      if @message.save
        @message.send_notification("#{@message.sender_name}, someone wants your stuff!", "Remember that stuff you mapped? Someone wants it! Check your messages to coordinate pickup of stuff", "Remember that stuff you mapped? <img src=\"#{@post.image.url(:medium)}\"> Someone wants it! Click <a href=\"http://stuffmapper.com\">this link</a> to coordinate pickup of stuff")
      end

      # message to dibber
      @message = Message.new()
      @message.sender_id = @post.creator_id
      @message.sender_name = User.find(@post.creator_id).name
      @message.receiver_id = session[:user_id]
      @message.receiver_name = User.find(session[:user_id]).name
      if (@post.on_the_curb)
        @message.content = 'Greetings. You just dibbed my stuff, pick it up soon :)'
      else
        @message.content = 'Greetings. You just dibbed my stuff, contact me to coordinate pickup of stuff :)'
      end
      @message.status = 'new'
      @message.ip = request.remote_ip
      if @message.save
        if (@post.on_the_curb)
          @message.send_notification("#{@message.sender_name}'s Dibs. Go get the stuff!", "#{@message.sender_name}, your Dibs is live and your priority access to the stuff's listing lasts for one hour. Click this link to view the listing!", "#{@message.sender_name}, your Dibs on <img src=\"#{@post.image.url(:medium)}\"> is live and your priority access to the stuff's listing lasts for one hour. Click <a href=\"http://stuffmapper.com\">this link</a> to view the listing!")
        else
          @message.send_notification("#{@message.sender_name}'s Dibs. Connect and coordinate pickup of stuff!", "#{@message.sender_name}, your Dibs on [insert image of stuff they Dibbed] is live and your priority access to the stuff's listing lasts for one hour. Click this link [insert link] to coordinate pickup!", "#{@message.sender_name}, your Dibs on [insert image of stuff they Dibbed] is live and your priority access to the stuff's listing lasts for one hour. Click <a href=\"http://stuffmapper.com\">this link</a> [insert link] to coordinate pickup!")
        end
      end
      respond_to do |format|
        format.json {render json: '[]', status: :ok}
      end
    else
      respond_to do |format|
        format.json {render json: [], status: :unprocessable_entity}
      end
    end
  end

  # POST /posts/geolocated.json
  def geolocated
    @posts = Post.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ? AND title ILIKE ? AND status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()) OR creator_id = ?)", params[:neLat], params[:swLat], params[:neLng], params[:swLng], "%#{params[:term]}%", 'new', session[:user_id]).limit(50)
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
    @posts = Post.where("title ILIKE ? AND status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()) OR creator_id = ?)", "%#{params[:term]}%", 'new', session[:user_id]).page(params[:page]).per(6)
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
