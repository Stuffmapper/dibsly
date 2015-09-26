class Api::DibsController < ApplicationController
  before_action :authorize

def create
  if params[:post_id] and current_user

    @post = Post.find(params[:post_id])
    dib = @post.create_new_dib(current_user, request.remote_ip)
    if dib.valid?
       render json: @post, status: :ok
    else
      render json: dib.errors , status: :unprocessable_entity
    end

  else
    render json: '[]', status: :unprocessable_entity
  end
end

def undib
  post = Post.find(params[:id])
  if current_user  && current_user == post.current_dibber
    post.remove_current_dib
    post.reload
    render json: '[]', status: :ok
  else
    render json: {message: "Dib not found"}, status: :unprocessable_entity
  end

end

def remove_dib
  #REVIEW ME - MAY USED A DIFFERENT STRATEGY
  dib = Dib.find(params[:id])

  if dib and dib.post.user == current_user
    dib.remove_as_dibber
    dib.report = Report.create(report_params)
    dib.save
    render json: {message: 'ok'} , status: :ok
  else
      render json: [], status: :unauthorized
  end

end



  private

  def report_params
      params.require(:report).permit(:rating, :description)
  end

  def authorize
    render json: {message: 'User not logged in' }, status: :unauthorized unless current_user
  end

end
