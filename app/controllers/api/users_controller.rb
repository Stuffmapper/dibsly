class Api::UsersController < ApplicationController
  before_action :correct_user, only: [:update ]
  before_action :authorize, only: [:index, :resend_verify ]
  # GET /users/1"111"
  # GET /users/1.json
  def show
  end

  def index
    render json: current_user, status: :ok
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params.merge(
            :ip => request.remote_ip,
            :status => 'new'))
    if @user.save
      session[:user_id] = @user.id
      render json: '[]', status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by_verify_email_token params[:confirmation]
    if user
      user.update_attributes :verified_email => true,
     :verify_email_token => nil
      render json: '[]', status: :ok
    else
      render json: { message: "User not Found "}, status: :unprocessable_entity
    end
  end
  def resend_verify
    current_user.resend_email_verification
    render json: '[]', status: :ok
  end

  def update
    user = current_user
    user.update_attributes user_params
    if user.update_attributes user_params
      render json: '[]', status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
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

    def correct_user
      if !current_user || current_user.id != params['id'].to_i
        render json: {error: 'not authorized '}, status: :unauthorized
      end
    end

   def authorize
    render json: {message: 'User not logged in' }, 
    status: :unauthorized unless current_user
  end
end
