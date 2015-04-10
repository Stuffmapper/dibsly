class DibsController < ApplicationController

def create
    if current_user && params[:post_id] 

      @post = Post.find(params[:post_id])
      dib = @post.create_new_dib(current_user, request.remote_ip)


      if dib.valid?
         render json: '[]', status: :ok
      else
        render json: dib.errors , status: :unprocessable_entity
      end

    else
      render json: '[]', status: :unprocessable_entity
    end
  end

  private
end
