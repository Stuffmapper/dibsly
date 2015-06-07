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

def undib
  post = Post.find(params[:id])

  if current_user && current_user.id == post.dibber_id
    post.remove_current_dib
    post.reload
    render json: '[]', status: :ok
  else
    render json: '[]', status: :unprocessable_entity
  end
  
end
  #part
def remove_dib
  if (current_user)
    #@posts = Post.where(:creator_id => current_user.id ).or(Post.where(:dibber_id => current_user.id ))
      render json: {message: 'ok'} , status: :ok
  else
      render json: {message: 'User not logged in' }, status: :unauthorized
  end
    
end



  private
end
