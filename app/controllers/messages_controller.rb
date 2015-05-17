class MessagesController < ApplicationController
  before_filter :verify_logged_in

  def index
    @messages = current_user.mailbox.conversations
    render json: @messages, status: :ok
  end

  def show
    #TODO paginate this
    conversation = current_user.mailbox.conversations.where(:id => params[:id])[0]
    get_messages_from_conversation(conversation)

    render json: @messages, each_serializer: ReceiptSerializer, status: :ok
  end

  def dib_or_post_chat
    @conversation = Mailboxer::Conversation.where(:id => params[:id])
    render json: @conversation, status: :ok
  end

  def reply
     conversation = current_user.mailbox.conversations.where(:id => params[:id])[0]
     #TODO make this more elegant
     if conversation.conversable_type == 'Dib'
        #dib status needs to be updated so messages go through dib model
        dib = conversation.conversable
        dib.contact_other_party(current_user, message_params[:body] )
     else
        current_user.reply_to_conversation(conversation, message_params[:body])
     end
     get_messages_from_conversation(conversation)
     render json: @messages, each_serializer: ReceiptSerializer, status: :ok    
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

      render json: @messages, each_serializer: ReceiptSerializer, status: :ok
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
      @messages = (conversation.receipts_for current_user).sort
    end
end
