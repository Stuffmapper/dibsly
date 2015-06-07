class Report < ActiveRecord::Base
	belongs_to :dib
	    	#has a rating
    	#0 - 10     01234    5    78910
    	#       negative  neutral positive
    	#description

end
