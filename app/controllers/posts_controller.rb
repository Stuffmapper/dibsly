class PostsController < ApplicationController
  before_action :set_post, only: [:show, :dib, :claim]


  # GET /posts
  # GET /posts.json

  #this is all stupid long hacked crap
  def index
    @posts = Post.where("status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()))", 'new').page(params[:page]).per(6)

    @posts.each do |post|

      #this should be part of the model _ on save
      #grr!!!!!!
      if ((post.image != nil) && (post.image_url == nil))
        post.image_url = post.image.url(:medium)
        post.save
      end
    end

    if (current_user)
      @post = Post.new(:on_the_curb => 1, :phone_number => current_user.phone_number)
      @message = Message.new()
    else
      @user = User.new

      #cookies.delete :first_time
      if cookies.permanent[:first_time] == nil
        cookies.permanent[:first_time] = 1
      else
        cookies.permanent[:first_time] = 0
      end
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
        data.original_filename = (Time.now.to_f * 1000).to_i.to_s
        data.content_type = urlSegments[1]
      end

      params.delete :image_url

      @post = Post.new(post_params.merge(:image_url => nil, :ip => request.remote_ip, :status => 'new', :creator_id => session[:user_id]))
      @post.image_url = nil
      @post.image = data

      respond_to do |format|
        if @post.save
          @post.image_url = @post.image.url(:medium)
          @post.save
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
      #put in separate method 
      @message = Message.new()
      @message.sender_id = session[:user_id]
      @message.sender_name = User.find(session[:user_id]).name
      @message.receiver_id = @post.creator_id
      @message.receiver_name = User.find(@post.creator_id).name
      if (@post.on_the_curb)
        @message.content = 'Greetings. I just dibbed your stuff, I\'ll pick it up soon :)'
      else
        @message.content = 'Greetings. I just dibbed your stuff, can you tell me when can I go to pick it up? :)'
      end
      @message.status = 'new'
      @message.ip = request.remote_ip
      if @message.save
        @message.send_notification("#{@message.receiver_name}, someone wants your stuff!",
                                   "#{@message.receiver_name}, someone Dibbed your stuff. Fabulous! Check your messages to contact Dibber.",
                                   "#{@message.receiver_name}, someone Dibbed your stuff. Fabulous! <a href='http://www.stuffmapper.com'>Click</a> to contact Dibber.")
      end

      # message to dibber
      # add to model

      @message = Message.new()
      @message.sender_id = @post.creator_id
      @message.sender_name = User.find(@post.creator_id).name
      @message.receiver_id = session[:user_id]
      @message.receiver_name = User.find(session[:user_id]).name
      if (@post.on_the_curb)
        @message.content = 'You just Dibbed my stuff! Go get it! :-)'
      else
        @message.content = 'Thanks for Dibbing my stuff! When will you come by to get it? :-)'
      end
      @message.status = 'new'
      @message.ip = request.remote_ip
      if @message.save
        if (@post.on_the_curb)
          @message.send_notification("Dibs confirmation", "#{@message.receiver_name}, your priority access to the mapping lasts for 12 hours. Check your messages to contact the Mapper!", "#{@message.receiver_name}, your priority access to the mapping lasts for 12 hours. <a href='http://www.stuffmapper.com'>Click</a> to contact the Mapper!")
        else
          @message.send_notification("#{@message.receiver_name}'s Dibs. Connect and coordinate pickup of stuff!", "#{@message.receiver_name}, your Dibs is live and your priority access to the stuff's listing lasts for 12 hours. Go to stuffmapper.com to coordinate pickup!", "#{@message.receiver_name}, your Dibs on <img src=\"#{@post.image_url}\"> is live and your priority access to the stuff's listing lasts for 12 hours. Click <a href=\"http://stuffmapper.com\">this link</a> to coordinate pickup!")
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

  # POST /posts/claim/1
  # POST /posts/claim/1.json
  def claim
    if (current_user) && (@post.status == 'new') && (@post.creator_id == current_user.id)
      @post.status = 'claimed'
      @post.save
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
    
    #if params[:term] == ''
    @posts = Post.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ? AND status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()))", 
              params[:neLat], params[:swLat], params[:neLng], params[:swLng], 'new').limit(50)
    #else
    #  @posts = Post.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ? AND title ILIKE ? AND status = ? AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()))", 
    #    params[:neLat], params[:swLat], params[:neLng], params[:swLng], "%#{params[:term]}%", 'new').limit(50)
    #end

    @term = params[:term]
    render json: @posts#Post.where("latitude <= 48 AND latitude >= 46 AND longitude <= -121 AND longitude >= -123 AND status = 'new' AND (dibbed_until IS NULL OR (dibbed_until IS NOT NULL AND dibbed_until <= NOW()))")

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

  # GET /posts/my_stuff
  def my_stuff
    @posts = Post.where("creator_id = ? OR dibber_id = ?", session[:user_id], session[:user_id]).page(params[:page]).per(6)
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
