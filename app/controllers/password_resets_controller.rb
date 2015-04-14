class PasswordResetsController < ApplicationController
	def create
		user = User.find_by(email: params[:email])
		
		if user 
			user.generate_password_reset_token!
			Notifier.password_reset(user).deliver
			render json: {message: "Instructions sent! Check your email"}, status: :ok
		else
			render json: {message: "Email not found"}, status: :unprocessable_entity
		end

	end

	private 

	def user_params
		params.require(:user).permit(:password, :password_confirmation )
	end

end
