require 'rails_helper'

RSpec.describe Api::MessagesController, :type => :controller do
	vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }


	before do
		@user = create(:user)
		@user2 = create(:user)
	end

	describe "Get index", :vcr => vcr_options do
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
		it "should return a conversation id" do
			@user2.send_message(@user,"Body","This is aSubject")

			sign_in(@user)

			xhr :get, :index
		    expect(response.status).to eq(200)
		    response_conversation_id = JSON.parse(response.body)['messages'][0]['id']
		    expect(response_conversation_id).to_not eq(nil)
		    expect(response_conversation_id).to eq(Mailboxer::Conversation.last.id)
		end
		it "should still work after a post has been created" do
			@post = create(:post, creator_id: @user.id, latitude: 1,longitude:2  )

			@user2.send_message(@user,"Body","This is aSubject")

			sign_in(@user)

			xhr :get, :index
		    expect(response.status).to eq(200)
		    response_first_subject = JSON.parse(response.body)['messages'][0]['subject']
		    expect(response_first_subject).to eq("This is aSubject")
		end

		it "should still work after a post has been created and dibbed" do
			@post = create(:post, creator_id: @user.id, latitude: 1,longitude:2 )
			@post.create_new_dib @user2
			@user2.send_message(@user,"Body","This is aSubject")

			expect(Mailboxer::Conversation.count).to eq 3


			sign_in(@user)

			xhr :get, :index
		    expect(response.status).to eq(200)
		    response_first_subject = JSON.parse(response.body)['messages'][0]['subject']
		    expect(response_first_subject).to eq("This is aSubject")
		end

		it "should include dib conversation" do
			@post = create(:post, creator_id: @user.id, latitude: '-122', longitude: '49' )
			@post.create_new_dib  @user2
			sign_in(@user2)
			xhr :get, :index
		    expect(response.status).to eq(200)
		    response_first_subject = JSON.parse(response.body)['messages'][0]['subject']
		    expect(response_first_subject).to eq("Stuffmapper dib for shoes")
		end

		it "should include information about the post" do
			@post = create(:post, creator_id: @user.id, description: "pretty decent shoes", latitude: '-122', longitude: '49' )
			@post.create_new_dib  @user2
			sign_in(@user2)
			xhr :get, :index
		    expect(response.status).to eq(200)
		    response_first_subject = JSON.parse(response.body)['messages'][0]['conversable']['description']
		    expect(response_first_subject).to eq("pretty decent shoes")
		end



	end

	describe "Get inbox_status", :vcr => vcr_options do
		it "shouldn't return count when not logged in" do
			xhr :get, :inbox_status
		    expect(response.status).to eq(401)
		end
		it "should return 200 when logged in" do
			sign_in(@user)
			xhr :get, :inbox_status
		    expect(response.status).to eq(200)
		end
		it "should not return a count without messages" do
			sign_in(@user)
			xhr :get, :inbox_status
			count = JSON.parse(response.body)['newMessages']
			expect(count).to eq(0)
		end
		it "should return a count with unread messages" do
			@user2.send_message(@user,"Body","This is aSubject")
			sign_in(@user)

			xhr :get, :inbox_status
		    expect(response.status).to eq(200)
		    count = JSON.parse(response.body)['newMessages']
		    expect(count).to eq(1)
		end

		it "shouldn't return a count with read messages" do
			@user2.send_message(@user,"Body","This is aSubject")
			conversation = @user.mailbox.inbox.first
			(conversation.receipts_for @user).each  do |receipt|
				receipt.mark_as_read
			end
			sign_in(@user)
			xhr :get, :inbox_status
				expect(response.status).to eq(200)
				count = JSON.parse(response.body)['newMessages']
				expect(count).to eq(0)
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
		it "should mark user messages as read" do
			(@conversation.receipts_for @user).each do |receipt|
				expect( receipt.is_read ).to eq false
			end
			sign_in(@user)
			xhr :get, :show, :id => @conversation.id

			@conversation.reload
			@user.reload

			(@conversation.receipts_for @user).each do |receipt|

				expect( receipt.is_read ).to eq true

			end
		end

		it "should return message created_at data" do

			sign_in(@user)
			xhr :get, :show, :id => @conversation.id
		    expect(response.status).to eq(200)
		    created_at = JSON.parse(response.body)['messages'][0]['created_at']
		    expect(Time.parse(created_at) < Time.now ).to eq true
		end

		it "should return message is read? data" do
			sign_in(@user)
			xhr :post, :reply , :id => @conversation.id , :message => {:body => "I'm replying to the last post" }
		    expect(response.status).to eq(200)

			xhr :get, :show, :id => @conversation.id
		    expect(response.status).to eq(200)
		    is_read = JSON.parse(response.body)['messages'][-1]['is_read']
		    expect( is_read ).to eq false

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
