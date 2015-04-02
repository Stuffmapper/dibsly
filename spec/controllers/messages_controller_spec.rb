require 'rails_helper'

RSpec.describe MessagesController, :type => :controller do
	
	before do
		@user = create(:user)
		@user2 = create(:user)
	end

	describe "Get message" do
		it "shouldn't return messages when not logged in" do 

			xhr :get, :index 
		    expect(response.status).to eq(401) 
		end
		it "should return 200 when logged in" do 
			sign_in(@user)

			xhr :get, :index 
		    expect(response.status).to eq(200) 
		end
		it "should return messages when logged in" do 
			@user2.send_message(@user,"Body","Subject")
   
			sign_in(@user)
			 
			xhr :get, :index 
		    expect(response.status).to eq(200) 
		    # expect(response.body).to eq("something to parse") 
		end

	end

end