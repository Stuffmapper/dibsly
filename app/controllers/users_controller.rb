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

  def confirm_email
  
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
