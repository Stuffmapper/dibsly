class Api::AlertsController < ApplicationController
  before_action :authorize
  before_action :find, only: [:update]

  def index
    @alerts = current_user.alerts.where(:read => false)
    render json: @alerts, status: :ok
  end

  def update
  	@alert.mark_as_read
  end

  private
  def authorize
    render json: {message: 'User not logged in' }, status: :unauthorized unless current_user
  end

  def find
   	@alert = Alert.find(params.id) 
    render json: '[]', status: :unprocessable_entity unless @alert and @alert.user == current_user
  end
end
