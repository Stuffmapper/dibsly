require 'rails_helper'

RSpec.describe DibsController, type: :controller do
	vcr_options = { :cassette_name => "aws_cucumber3", :match_requests_on => [:method] }

	describe "dib post", :vcr => vcr_options do
		 
		before do
  		  	@user = create(:user)
        	@user2 = create(:user)
        	@post = create(:post, creator_id: @user.id, longitude: 0, latitude:0  ) 	
		end
		context 'without login' do
			it 'should return 401' do 
				xhr :post, :create, :post_id => @post.id  
		     	expect(response.status).to eq(401) 
			end
		end	
		context 'with login' do

			it 'should return 200 with params' do 
				sign_in(@user2)
				xhr :get, :create, :post_id => @post.id  
		     	expect(response.status).to eq(200) 
			end
			it 'should send a message to the lister' do 
				sign_in(@user2)
				xhr :get, :create, :post_id => @post.id  
		     	expect(response.status).to eq(200) 
		     	conversation =  @user.mailbox.inbox.last
      			receipts = conversation.receipts_for @user
      			receipts.each {|receipt| expect(receipt.message.body).to have_text("dibbed your stuff!") }
			end
			it 'should send  a message to dibber' do 
				sign_in(@user2)
				expect(Notifier).to receive(:dibber_notification).and_call_original 
				xhr :get, :create, :post_id => @post.id  
		    end

			it 'should not allow you to dib your own stuff' do 
				sign_in(@user)
				xhr :get, :create, :post_id => @post.id  
		     	expect(response.status).to eq(422) 
		     	expect(response.body).to eq("{\"dib\":[\"You can't dib your own stuff\"]}") 
			end

			it 'should not allow you to dib dibbed stuff' do 
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
			it 'should return 401' do 
				xhr :patch, :undib, :id => @post.id  
		     	expect(response.status).to eq(401) 
			end
		end	
		context 'with login' do

			it 'should return 200 with params' do 
				sign_in(@user2)
				xhr :patch, :undib, :id => @post.id  
		     	expect(response.status).to eq(200) 
			end
			it 'should undib  200 with params' do 
				expect(@post.current_dibber).to eq(@user2)
				sign_in(@user2)
				xhr :patch, :undib, :id => @post.id 
		     	expect(response.status).to eq(200)
		     	@post.reload
		     	expect(@post.current_dibber).to eq(nil)
		     	

			end

			it 'should respond on the dib\'s conversation' do
				sign_in(@user2)
				xhr :patch, :undib, :id => @post.id 
		     	expect(response.status).to eq(200)

		     	@post2 = create(:post, creator_id: @user.id, longitude: 0, latitude:0  )
		     	@post2.create_new_dib @user2

		     	@post.reload
		     	@user2.reload

		     	conversation =  @post.dibs[0].conversation.receipts_for @user2
		     	expect(conversation[0].message.body).to eq ( @user2.username + ' has undibbed your stuff')

			end

		end
	end
	describe "Post removedib", :vcr => vcr_options do
		before do
			two_users_post_dib
		end

		context "without login " do 

			it 'should 401' do 
				xhr :post, :remove_dib, :id => @dib.id 
		     	expect(response.status).to eq(401) 
			end
		end
		context "with login " do 
			before do 
				sign_in(@user)
			end 

			it 'should 200' do 
				xhr :post, :remove_dib, :id => @dib.id, :report => 
				{ :rating => '6', :description => 'user confused about description'}
		     	expect(response.status).to eq(200) 
			end
			it 'should make the post available to dib ' do 
				xhr :post, :remove_dib, :id => @dib.id, :report => 
				{ :rating => '6', :description => 'user confused about description'}
		     	expect(response.status).to eq(200) 
		     	@post.reload
		     	expect(@post.available_to_dib?).to eq true
			end
			it 'should remove a dibber from post' do 
				expect(@post.current_dibber ).to eq(@user2 ) 
				sign_in(@user)
				xhr :post, :remove_dib, :id => @dib.id, :report => 
				{ :rating => '6', :description => 'item picked up'}
				@post.reload
		     	expect(@post.current_dibber ).to eq(nil) 
			end
			it 'should create a report ' do 
				expect(Report.count ).to eq 0
				expect(@post.current_dibber ).to eq(@user2) 
				sign_in(@user)
				xhr :post, :remove_dib, :id => @dib.id, :report => 
				{ :rating => '6', :description => 'other'}
				@post.reload
				expect(Report.count ).to eq 1 
				@post.reload
		     	expect(@post.current_dibber ).to eq(nil) 
		     	expect(@dib.report.sentiment).to eq 'positive'
			end
			it 'should not work with an unrelated user create a report ' do 
				expect(Report.count ).to eq 0
				expect(@post.current_dibber ).to eq(@user2 ) 
				@user3 = create(:user)
				sign_in(@user3)
				xhr :post, :remove_dib, :id => @dib.id, :report => 
				{ :rating => '6', :description => 'other'}
				@post.reload
				expect(Report.count ).to eq 0
		     	expect(@post.current_dibber ).to eq(@user2) 
			end

			it 'should not work with a the dibber to create a report ' do 
				expect(Report.count ).to eq 0
				expect(@post.current_dibber ).to eq(@user2 ) 
				sign_in(@user2)
				xhr :post, :remove_dib, :id => @dib.id, :report => 
				{ :rating => '6', :description => 'other'}
				@post.reload
				expect(Report.count ).to eq 0
		     	expect(@post.current_dibber ).to eq(@user2) 
			end
		end


	end

end
