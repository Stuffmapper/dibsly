class Api::PoliciesController < ApplicationController


  def terms_of_use
    #use language here

    render json: { :terms=> ( I18n.t 'termsofuse' ) }, status: :ok
  end

  def privacy
    #use language here
    render json: { :privacy=> ( I18n.t 'privacy' ) }, status: :ok
  end

end
