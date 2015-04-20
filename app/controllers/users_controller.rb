class UsersController < ApplicationController

  # GET /users/1"111"
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params.merge(
            :ip => request.remote_ip,
            :status => 'new'))
    if  @user.save
      session[:user_id] = @user.id
      render json: '[]', status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  
  end
  def user_geolocation
    user_ip = request.location
    
    if user_ip && !user_ip.longitude == 0.0
      user_location = { :location =>  user_ip.longitude.to_s + ', ' + user_ip.latitude.to_s }
    else
      user_location = {:location => '47.6097,-122.3331'}
    end
    render json: user_location , status: :ok

  end

  # POST /users
  # POST /users.json




  # POST /users/presets.json
  def presets
    if !session[:latitude]
      session[:latitude] = 47.6612588;
    end
    if !session[:longitude]
      session[:longitude] = -122.3078193;
    end
    if !session[:zoom]
      session[:zoom] = 14;
    end
    if !session[:grid_mode]
      session[:grid_mode] = true;
    end

    respond_to do |format|
      format.json {render json: '{"latitude":'+session[:latitude].to_s+',
        "longitude":'+session[:longitude].to_s+',
        "zoom":'+session[:zoom].to_s+',
        "grid_mode":'+session[:grid_mode].to_s+'}', status: :ok}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, 
    # only allow the white list through.
    def user_params
      params.require(:user).permit(
          :first_name,
          :last_name,
          :username,
          :email,
          :password,
          :password_confirmation,
          :address,
          :latitude,
          :longitude,
          :on_the_curb,
          :phone_number,
          :anonymous)
    end
end
