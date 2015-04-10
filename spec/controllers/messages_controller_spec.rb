require 'rails_helper'

RSpec.describe MessagesController, :type => :controller do
	
	before do
		@user = create(:user)
		@user2 = create(:user)
	end

	describe "Get index" do
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
			@user2.send_message(@user,"Body","This is aSubject")
   
			sign_in(@user)
			 
			xhr :get, :index 
		    expect(response.status).to eq(200) 
		    response_first_subject = JSON.parse(response.body)['messages'][0]['subject']
		    expect(response_first_subject).to eq("This is aSubject") 
		end

	end
	describe "Get show conversation" do
		before do 
			@user2.send_message(@user,"This is the Body","This is aSubject")
			@conversation =  @user.mailbox.inbox.last
      	end
      	
		it "shouldn't return messages when not logged in" do 
			xhr :get, :show, :id => @conversation.id  
		    expect(response.status).to eq(401) 
		end
		it "should return 200 when logged in" do 
			sign_in(@user)
			xhr :get, :show, :id => @conversation.id  
		    expect(response.status).to eq(200) 
		end

		it "should return messages for conversation to be returned" do 
			sign_in(@user)
			xhr :get, :show, :id => @conversation.id  
		    expect(response.status).to eq(200) 
		    response_first_body = JSON.parse(response.body)['messages'][0]['body']
		    expect(response_first_body).to eq('This is the Body')
		end

		it "should return the sender's username " do 
			sign_in(@user)
			xhr :get, :show, :id => @conversation.id  
		    expect(response.status).to eq(200) 
		    response_first_sender = JSON.parse(response.body)['messages'][0]['sender']
		    expect(response_first_sender).to eq(@user2.username)
		end
	end

	describe "Post reply to conversation" do
		before do 
			@user2.send_message(@user,"This is the Body","This is aSubject")
			@conversation =  @user.mailbox.inbox.last
      	end
      	#receipts.each {|receipt| expect(receipt.message.body).to eq("#{@user2.username} Has dibbed your stuff") }

		it "shouldn't return messages when not logged in" do 
			xhr :post, :reply, :id => @conversation.id 
		    expect(response.status).to eq(401) 
		end
		it "should return 200 when logged in" do 
			sign_in(@user)
			xhr :post, :reply , :id => @conversation.id , :message => {:body => "I'm replying to the last post" }
		    expect(response.status).to eq(200) 
		end

		it "should return messages for conversation to be returned" do 
			sign_in(@user)
			xhr :post, :reply , :id => @conversation.id , :message => {:body => "I'm replying to the last post" } 
		    expect(response.status).to eq(200) 
		    response_first_body = JSON.parse(response.body)['messages'][-1]['body']
		    expect(response_first_body).to eq("I'm replying to the last post")
		end
	end
	describe "Post new message" do
		before do 
			@user2.send_message(@user,"This is the Body","This is aSubject")
			@conversation =  @user.mailbox.inbox.last
      	end
      	#receipts.each {|receipt| expect(receipt.message.body).to eq("#{@user2.username} Has dibbed your stuff") }

		it "shouldn't return messages when not logged in" do 
			xhr :post, :create,:message => {:receiver_username => @user2.username ,:subject=> "something", :body => "Now about that stuff" }
		    expect(response.status).to eq(401) 
		end
		it "should return 200 when logged in" do 
			sign_in(@user)
			xhr :post, :create,:message => {:receiver_username => @user2.username ,:subject=> "something", :body => "Now about that stuff" }
		    expect(response.status).to eq(200) 
		end

		it "should return messages for conversation to be returned" do 
			sign_in(@user)
			xhr :post, :create,:message => {:receiver_username => @user2.username ,:subject=> "something", :body => "Now about that stuff" }
			expect(response.status).to eq(200) 
		    response_first_body = JSON.parse(response.body)['messages'][0]['body']
		    expect(response_first_body).to eq("Now about that stuff" )
		end
	end

end