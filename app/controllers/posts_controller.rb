class PostsController < ApplicationController
 
  before_action :set_post, only: [:show, :dib, :claim]
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


end
