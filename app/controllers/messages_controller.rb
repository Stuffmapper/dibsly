class MessagesController < ApplicationController
  before_action :set_message, only: [:show]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.where("sender_id = ? OR receiver_id = ?", session[:user_id], session[:user_id]).page(params[:page]).per(5)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    @message.receiver_id(params[:receiver_id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params.merge(:ip => request.remote_ip, :status => 'new', :sender_id => session[:user_id]))

    # ensures that the models errors array is populated so that if the captcha is incorrect the user will see that message as well as all the model error validation messages.
    @message.valid?
    if @message.save
      format.json {render json: '[]', status: :ok}
    else
      format.json {render json: @message.errors, status: :unprocessable_entity}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id]).where("sender_id = ? OR receiver_id = ?", session[:user_id], session[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).require(:message).permit(:ip, :status, :sender_id, :message)
    end
end
