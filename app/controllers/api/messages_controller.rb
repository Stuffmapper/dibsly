class Api::MessagesController < ApplicationController
  before_filter :verify_logged_in

  def inbox_status
    count = current_user.alerts.where(:read => false).count
    render json: { newMessages: count}, status: :ok
  end

  def index
    @messages = current_user.alerts
    render json: @messages, each_serializer: AlertSerializer, status: :ok
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
