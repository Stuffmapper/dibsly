class Api::AlertsController < ApplicationController
  before_action :authorize
  before_action :find, only: [:update]

  def index
    render json: current_user.alerts.where(:read => false), status: :ok
  end

  def update
  	@alert.update_attribute(:read, true) 
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
