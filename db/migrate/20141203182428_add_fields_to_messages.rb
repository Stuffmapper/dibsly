class AddFieldsToMessages < ActiveRecord::Migration
  def change

    
	 Message.find_each do |message|
	    if message.subject.nil?
	      	 message.subject = " "
	      	 message.save
	    end

	  end

	end
end
