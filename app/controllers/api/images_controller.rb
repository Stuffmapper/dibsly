class Api::ImagesController < ApplicationController
  before_action :authorize

  def create
    @image = Image.create( image: image_params[:image] )
    @imageable.update_picture @image
    if @image.save
      render json: @image, status: :ok
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  private

    def image_params
      params.permit(:image, :type, :id)
    end

    def authorize
      @imageable = false
      if current_user and image_params[:type] == 'post'
        post = Post.find(image_params[:id])
        @imageable = post.creator == current_user ? post : false
      end
      if current_user and image_params[:type] == 'user'
        #TODO fix - it's not going to work this way
        @imageable =  image_params[:id] == current_user.id ? current_user : false
      end
      render json: {message: 'User not logged in' }, status: :unauthorized unless current_user and @imageable
    end

end
