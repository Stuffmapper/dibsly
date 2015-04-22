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
      			receipts.each {|receipt| expect(receipt.message.body).to eq("#{@user2.username}'s dibbed your stuff!") }
			end
			it 'should not allow you to dib your own stuff' do 
				sign_in(@user)
				xhr :get, :create, :post_id => @post.id  
		     	expect(response.status).to eq(422) 
		     	expect(response.body).to eq("{\"dib\":[\"You can't dib your own stuff\"]}") 
			end

			it 'should not allow you to dib dibed stuff' do 
				sign_in(@user2)
				@post.create_new_dib(@user2)
				assert @post.available_to_dib? == false
				xhr :get, :create, :post_id => @post.id  
		     	expect(response.body).to eq("{\"dib\":[\"post not available to dib\"]}") 
		     end

		end
	end
	describe "undib post", :vcr => vcr_options do
		 
		before do
  		  	@user = create(:user)
        	@user2 = create(:user)
        	@post = create(:post, creator_id: @user.id, longitude: 0, latitude:0  ) 	
			@post.create_new_dib @user2
		end
		context 'without login' do
			it 'should return 422' do 
				xhr :patch, :undib, :id => @post.id  
		     	expect(response.status).to eq(422) 
			end
		end	
		context 'with login' do

			it 'should return 200 with params' do 
				sign_in(@user2)
				xhr :patch, :undib, :id => @post.id  
		     	expect(response.status).to eq(200) 
			end
			it 'should undib e 200 with params' do 
				expect(@post.dibber_id).to eq(@user2.id)
				sign_in(@user2)
				xhr :patch, :undib, :id => @post.id 
		     	expect(response.status).to eq(200)
		     	@post.reload
		     	expect(@post.dibber_id).to eq(nil)
		     	

			end
			# it 'should not allow you to dib your own stuff' do 
			# 	sign_in(@user)
			# 	xhr :get, :create, :post_id => @post.id  
		 #     	expect(response.status).to eq(422) 
		 #     	expect(response.body).to eq("{\"dib\":[\"You can't dib your own stuff\"]}") 
			# end

			# it 'should not allow you to undib other peoples dibed stuff' do 
			# 	sign_in(@user2)
			# 	@post.create_new_dib(@user2)
			# 	assert @post.available_to_dib? == false
			# 	xhr :get, :create, :post_id => @post.id  
		 #     	expect(response.body).to eq("{\"dib\":[\"post not available to dib\"]}") 
		 #     end

		end
	end

end
