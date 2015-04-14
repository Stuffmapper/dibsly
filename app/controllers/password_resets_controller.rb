class PasswordResetsController < ApplicationController
	def create
		render json: '[]'
		
	end

	private 

	def user_params
		params.require(:user).permit(:password, :password_confirmation )
	end

end
