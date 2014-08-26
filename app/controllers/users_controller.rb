class UsersController < ApplicationController
  before_action :set_user, only: [:show, :my_stuff]

  # GET /users/1"111"
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params.merge(:ip => request.remote_ip, :status => 'new'))
    @user.latitude = session[:latitude]
    @user.longitude = session[:longitude]
    @user.zoom = session[:zoom]
    @user.grid_mode = session[:grid_mode]

    respond_to do |format|
      # ensures that the models errors array is populated so that if the captcha is incorrect the user will see that message as well as all the model error validation messages.
      @user.valid?
      if verify_recaptcha(:model => @user, :attribute => 'captcha', :message => ' is invalid') && @user.save
        session[:user_id] = @user.id
        format.json {render json: '[]', status: :ok}
      else
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  # POST /users
  # POST /users.json
  def my_stuff
    respond_to do |format|
      @user.valid?
      if @user.update(user_params)
        format.json {render json: '[]', status: :ok}
      else
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end



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
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :address, :latitude, :longitude, :on_the_curb, :phone_number)
    end
end
