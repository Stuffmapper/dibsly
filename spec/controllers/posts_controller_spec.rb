require 'rails_helper'

RSpec.describe PostsController, :type => :controller do
	vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }
	
	describe "Get geolocated", :vcr => vcr_options do
		 

		before do
			@user = create(:user)
		    @post = build(:post, creator_id: @user.id )
	
	
		#Paperclip::Attachment.any_instance.stub(:save_attached_files).and_return(true)
	
		end
		context "when there are far and near posts " do
			before do
			   @post.latitude = '49'
			   @post.longitude = '-122'
			   @post.save!
			end

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
		       parsed_response = JSON.parse(response.body.as_json)
			   expect(parsed_response['posts'][0]['id'] ).to eq @post.id
			   expect(parsed_response['posts'][0]['coords'] ).to eq JSON.parse('{"latitude":47.0, "longitude":-122.0}')
			   expect(response.status).to eq(200)
			end
			
			it "does not returns post out of scope " do

			   xhr :get, :geolocated, :neLat => 48, :neLng => -121, :swLat => 46, :swLng => -123
		       #ugly need to fix
		       parsed_response = JSON.parse(response.body.as_json)
			   expect(parsed_response['posts'][0]).to eq nil
			   expect(response.status).to eq(200)   

			end
			it "does not returns post out of scope " do
			  
			   xhr :get, :geolocated, :neLat => 48, :neLng => -121, :swLat => 46, :swLng => -123
		       #ugly need to fix
		       parsed_response = JSON.parse(response.body.as_json)
			   expect(parsed_response['posts'][0]).to eq nil
			   expect(response.status).to eq(200)   
			end
			it "returns a post with an image_url" do
			   
			   @post.latitude = '47'
			   @post.longitude = '-122'
			   @post.save!
			   xhr :get, :geolocated, :neLat => 48, :neLng => -121, :swLat => 46, :swLng => -123
		       #ugly need to fix
		       parsed_response = JSON.parse(response.body.as_json)
			   expect(parsed_response['posts'][0]['id'] ).to eq @post.id
			   expect(parsed_response['posts'][0]['image_url'] ).to match(/http:\/\/s3-us-west-2.amazonaws.com\/stuffmapper-test\/posts\/image/)
			   expect(response.status).to eq(200)
			end
		end
	end
	describe "Post create post", :vcr => vcr_options do
		before do
			@user = create(:user)
		end

		context "without login " do 

			it 'should 401' do 
				xhr :post, :create 
		     	expect(response.status).to eq(401) 
			end
		end

		context "with login", :vcr => vcr_options do 
			before do
			shoes = File.read("spec/factories/shoes.png")
			@file = fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png')
			end


			it 'should 422 with incomplete data' do 
				sign_in(@user)
				xhr :post, :create, {title:''} 
				expect(response.body).to eq("{\"image\":[\"can't be blank\"],\"longitude\":[\"can't be blank\"],\"latitude\":[\"can't be blank\"]}")
		     	expect(response.status).to eq(422) 
			end
			it 'should 422 without location data' do 
				sign_in(@user)
				xhr :post, :create, {title:'', image: @file } 
				expect(response.body).to eq("{\"longitude\":[\"can't be blank\"],\"latitude\":[\"can't be blank\"]}")
				expect(response.status).to eq(422) 
			end
			
			it 'should 200 with complete data' do 
				sign_in(@user)
				xhr :post, :create, {title:'', image: @file, latitude:'47',longitude:'-122' } 
				expect(response.status).to eq(200) 
			end


		end
	end
	describe "Get mystuff", :vcr => vcr_options do
		 

		before do
			@user = create(:user)
		    create(:post, creator_id: @user.id, latitude:'47',longitude:'-122'  ) 
		end
		context 'without login' do
			it 'should return 401' do 
				xhr :get, :my_stuff 
		     	expect(response.status).to eq(401) 

			end
		end
				
		context 'with login' do

			it 'should return 200' do 
				sign_in(@user)
				xhr :get, :my_stuff 
		     	expect(response.status).to eq(200) 
			end


			it 'should return my stuff' do 
				sign_in(@user)
				xhr :get, :my_stuff 
				parsed_response = JSON.parse(response.body.as_json)
				expect(parsed_response['posts'][0]['coords'] ).to eq JSON.parse('{"latitude":47.0, "longitude":-122.0}')
				expect(response.status).to eq(200)
			end
		end
	end
	
end
