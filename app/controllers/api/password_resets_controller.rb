class Api::PasswordResetsController < ApplicationController
	def create
		user = !params[:email].nil? ? User.find_by(email: params[:email].downcase ) : nil

		if user
			user.generate_password_reset_token!
			Notifier.password_reset(user).deliver_later
			render json: {message: "Reset instructions sent! Check your email!"}, status: :ok
		else
			render json: {message: "User not found"}, status: :unprocessable_entity
		end
	end
	
	def edit
		@user = User.find_by(password_reset_token: params[:id] )
		if @user
			render json: {message: "[]"}, status: :ok
		else
			render json: {message: "User not found"}, :status => 404
		end


	end
	def update
		@user = User.find_by(password_reset_token: params[:id] )
		if @user && @user.update_attributes(user_params)
			@user.update_attribute(:password_reset_token, nil)
			session[:user_id] = @user.id
			render json: {message: "Password update" }, status: :ok
		else
			render json: {message: "Password token not found" }, :status => 401
		end

	end


	private

	def user_params
		params.require(:user).permit(:password, :password_confirmation )
	end

end
