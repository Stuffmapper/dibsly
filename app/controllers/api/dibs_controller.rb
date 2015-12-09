class Api::DibsController < ApplicationController
  before_action :authorize
  before_action :authorize_message, only: [:send_message, :messages, :mark_read, :unread ]

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
    @post = Post.find(params[:id])
    if current_user  && current_user == @post.current_dibber
      dib = @post.current_dib
      @post.remove_current_dib
      @post.notify_undib dib
      @post.reload
      render json: @post, status: :ok
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

  def send_message
    @dib.contact_other_party(current_user, message_params[:body] )
    @messages = (@dib.conversation.receipts_for current_user).sort
    render json: @messages, each_serializer: ReceiptSerializer, status: :ok
  end
  
  def messages
    @messages = (@dib.conversation.receipts_for current_user).sort
    render json: @messages, each_serializer: ReceiptSerializer, status: :ok
  end
  
  def mark_read
    @messages = @dib.conversation.receipts_for current_user
    @messages.each  do |receipt|
      receipt.mark_as_read
    end
    render json: @messages, each_serializer: ReceiptSerializer, status: :ok

  end
  
  def unread
    #authorizes
    @messages = (@dib.conversation.receipts_for current_user).where(:is_read=>false)
    render json: @messages, each_serializer: ReceiptSerializer, status: :ok
  end



  private

  def report_params
      params.require(:report).permit(:rating, :description)
  end
  

  def message_params
    params.require(:message).permit(:body)
  end



  def authorize
    render json: {message: 'User not logged in' }, status: :unauthorized unless current_user
  end

  def authorize_message
    @dib = Dib.find(params[:dib_id])
    if not @dib
      render json: {message: "Dib not found"}, status: :unprocessable_entity
    elsif @dib.user != current_user and @dib.post.creator != current_user
      render json: {message: 'unauthorized user ' }, status: :unauthorized
    end
  end

end
