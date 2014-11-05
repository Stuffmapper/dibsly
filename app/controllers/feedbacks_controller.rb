class FeedbacksController < ApplicationController
  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params.merge(:ip => request.remote_ip))

    if @feedback.save
      render json: '[]', status: :ok
    else
      render json: '[]', status: :unprocessable_entity
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.permit(:email, :message)
    end
end
