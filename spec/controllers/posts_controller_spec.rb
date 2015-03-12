require 'rails_helper'


RSpec.describe PostsController, :type => :controller do
	vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }
	
	describe "Get geolocated", :vcr => vcr_options do
		 

		before do
			@user = create(:user)
		    @post = create(:post, creator_id: @user.id )
	
	
		#Paperclip::Attachment.any_instance.stub(:save_attached_files).and_return(true)
	
		end
		context "when there are far and near posts " do

			it "200 does" do

			  xhr :get, :geolocated
			  expect(response.body).to eq "{\"posts\":[]}"
			  expect(response.status).to eq(200)
 
			end

			it "only returns a nearby post" do
			   
			   @post.latitude = '47'
			   @post.longitude = '-122'
			   @post.save!
			   xhr :get, :geolocated, :neLat => 48, :neLng => -121, :swLat => 46, :swLng => -123
		       #ugly need to fix
			   expect(JSON.parse(response.body.as_json)['posts'][0]).to eq JSON.parse(@post.to_json)
			   expect(response.status).to eq(200)
			end
			
			it "does not returns post out of scope " do
			   
			   @post.latitude = '49'
			   @post.longitude = '-122'
			   @post.save!
			   xhr :get, :geolocated, :neLat => 48, :neLng => -121, :swLat => 46, :swLng => -123
		       #ugly need to fix
			   expect(JSON.parse(response.body.as_json)['posts'][0]).to eq nil
			   expect(response.status).to eq(200)   
 


			end
		end
	end
end
