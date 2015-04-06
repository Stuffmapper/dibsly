class MessagesController < ApplicationController
  before_filter :verify_logged_in

  def index
    @messages = current_user.mailbox.inbox
    render json: @messages, status: :ok
  end

  def show
    conversation = current_user.mailbox.conversations.where(:id => params[:id])[0]
    receipts = conversation.receipts
    messages = receipts.collect{ |receipt| receipt.message }
    render json: messages, status: :ok
  
  end

  def reply
     conversation = current_user.mailbox.conversations.where(:id => params[:id])[0]
     current_user.reply_to_conversation(conversation, message_params[:body])
     get_messages_from_conversation(conversation)
     render json: @messages, status: :ok
     
  end

  # POST /messages
  # POST /messages.json
  def create
    if message_params[:receiver_username].present? and message_params[:body].present?
      receipient = User.find_by_username(message_params[:receiver_username])

      subject, body = message_params[:subject], message_params[:body]
      current_user.send_message(receipient, body, subject)

      conversation = current_user.mailbox.conversations.first

      get_messages_from_conversation(conversation)

      render json: @messages, status: :ok
    else
      render json: '[]',  status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def verify_logged_in
      if not current_user
        render json: '[]', status: :unauthorized
      end
    end

    # Never trust parameters from the scary internet, 
    # only allow the white list through.
    def message_params
      params.require(:message).permit(:receiver_username, :body, :subject)
    end

    def get_messages_from_conversation conversation
      receipts = conversation.receipts
      @messages = receipts.collect{ |receipt| receipt.message }
    end
end
