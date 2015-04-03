class MessagesController < ApplicationController
  before_action :only_for_user, only: [:index]
  before_filter :verify_logged_in


  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.where("receiver_id = ?",
            session[:user_id]).page(params[:page]).per(5)
    render json: @messages, status: :ok
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params.merge(
            :ip => request.remote_ip,
            :status => 'new',
            :sender_id => session[:user_id],
            :sender_name => User.find(session[:user_id]).name,
            :receiver_name =>  User.find(message_params[:receiver_id]).name))

    # ensures that the models errors array is populated so that if the captcha
    # is incorrect the user will see that message as well as all the model 
    # error validation messages.
    respond_to do |format|
      @message.valid?
      if @message.save
        @message.send_notification(
                "You just got a message!",
                "Please, go to Stuffmapper.com to check it out.",
                "Please, go to <a href=\"http://stuffmapper.com\">
                 Stuffmapper.com</a> to check it out.")
        format.json {
                render json: '[]',
                status: :ok
        }
      else
        format.json {
                render json: @message.errors, 
                status: :unprocessable_entity
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def only_for_user
      @message = Message.where("receiver_id = ?", session[:user_id])
    end

    def verify_logged_in
      if not current_user
        render json: '[]', status: :unauthorized
      end
    end

    # Never trust parameters from the scary internet, 
    # only allow the white list through.
    def message_params
      params.require(:message).permit(:receiver_id, :content)
    end
end
