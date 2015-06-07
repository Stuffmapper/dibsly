class Report < ActiveRecord::Base
	belongs_to :dib
    def sentiment
    	things = { 0..4 => "negative",
        5 => "neutral",
       6..10 => "positive"}.select{ |key| key === self.rating }.values.first
    end


end
