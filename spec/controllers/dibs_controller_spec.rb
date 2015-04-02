require 'rails_helper'

RSpec.describe DibsController, type: :controller do
	vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }

	describe "dib post", :vcr => vcr_options do
		 
		before do
  		  	@user = create(:user)
        	@user2 = create(:user)
        	@post = create(:post, creator_id: @user.id, longitude: 0, latitude:0  ) 	
		end
		context 'without login' do
			it 'should return 422' do 
				xhr :post, :create, :post_id => @post.id  
		     	expect(response.status).to eq(422) 
			end
		end	
		context 'with login' do

			it 'should return 200 with params' do 
				sign_in(@user2)
				xhr :get, :create, :post_id => @post.id  
		     	expect(response.status).to eq(200) 
			end
			it 'should create a message 200 with params' do 
				sign_in(@user2)
				xhr :get, :create, :post_id => @post.id  
		     	expect(response.status).to eq(200) 
		     	conversation =  @user.mailbox.inbox.last
      			receipts = conversation.receipts_for @user
      			receipts.each {|receipt| expect(receipt.message.body).to eq("#{@user2.username} Has dibbed your stuff") }
			end

		end
	end

end
