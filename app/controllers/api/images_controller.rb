class Api::ImagesController < ApplicationController
  before_action :authorize

  def create
    @image = Image.create( image_params )
    if @image.save
      render json: @image, status: :ok
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  private

    def image_params
      params.permit(:image)
    end

    def authorize
      render json: {message: 'User not logged in' }, status: :unauthorized unless current_user
    end

end
