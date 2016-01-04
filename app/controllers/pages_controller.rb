class PagesController < ApplicationController

  def privacy
    #use language here
    @policy =  I18n.t 'privacy'   
    render 'policy'
  end
  
  def splash
  end

  def support

  end


  def terms_of_use
    #use language here
    @policy =  I18n.t 'termsofuse' 
    render 'policy'
  end

  def jobs

  end

end
