require 'rails_helper'

RSpec.describe Api::MessagesController, :type => :controller do
	vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }

	describe "Get index", :vcr => vcr_options do
		before do
	    	two_users_post_dib
		end
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
			@dib.contact_other_party @user2,"This is the body"

			sign_in(@user)

			xhr :get, :index
		    expect(response.status).to eq(200)
		    response_first_body = JSON.parse(response.body)['messages'][1]['body']
		    expect(response_first_body).to eq("This is the body")
		end

	end

	describe "Get inbox_status", :vcr => vcr_options do
		it "shouldn't return count when not logged in" do
			xhr :get, :inbox_status
		    expect(response.status).to eq(401)
		end
		it "should return 200 when logged in" do
	    	two_users_post_dib
			sign_in(@user)
			xhr :get, :inbox_status
		    expect(response.status).to eq(200)
		end
		it "should not return a count without messages" do
			two_users_post_dib
			@user.alerts.each{ |message| message.mark_as_read }
			sign_in(@user)
			xhr :get, :inbox_status
			count = JSON.parse(response.body)['newMessages']
			expect(count).to eq(0)
		end
		it "should return a count with unread messages" do
			two_users_post_dib
			@dib.contact_other_party(@user2,"This is aSubject")
			sign_in(@user)
			xhr :get, :inbox_status
		    expect(response.status).to eq(200)
		    count = JSON.parse(response.body)['newMessages']
		    expect(count).to eq(2)
		end

		it "shouldn't return a count with read messages" do
			two_users_post_dib
			@dib.contact_other_party @user2,"This is aSubject"
			conversation = @user.alerts
			conversation.each  do |receipt|
				receipt.mark_as_read
			end
			sign_in(@user)
			xhr :get, :inbox_status
				expect(response.status).to eq(200)
				count = JSON.parse(response.body)['newMessages']
				expect(count).to eq(0)
		end
	end

end
