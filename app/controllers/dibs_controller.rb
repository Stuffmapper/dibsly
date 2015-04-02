class DibsController < ApplicationController


def create
    if current_user && params[:post_id] 

      @post = Post.find(params[:post_id])
    
      if @post.available_to_dib?
         @post.create_new_dib(current_user, request.remote_ip)
         render json: '[]', status: :ok 
      end
    else
      render json: '[]', status: :unprocessable_entity
    end
  end

  private


end
