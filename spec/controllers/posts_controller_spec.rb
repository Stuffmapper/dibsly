require 'rails_helper'
require "base64"

RSpec.describe Api::PostsController, :type => :controller do
  vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }

  describe "Get geolocated posts", :vcr => vcr_options do


    before do
      @user = create(:user)
      @post = build(:post, creator_id: @user.id )

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
         xhr :get, :geolocated, :nwLat => 48, :nwLng => -123, 
         :seLat => 46, :seLng => -121
           #ugly need to fix
           parsed_response = JSON.parse(response.body.as_json)
         expect(parsed_response['posts'][0]['id'] ).to eq @post.id
        expect(parsed_response['posts'][0]['latitude']).to eq 47
        expect(parsed_response['posts'][0]['longitude']).to eq -122
         expect(response.status).to eq(200)
      end
      it "does not return published posts" do

         @post.latitude = '47'
         @post.longitude = '-122'
         @post.published = false
         @post.save!
         xhr :get, :geolocated, :nwLat => 48, :nwLng => -121, 
         :seLat => 46, :seLng => -123
           #ugly need to fix
           parsed_response = JSON.parse(response.body.as_json)
         expect(parsed_response['posts'][0]).to eq nil
         expect(response.status).to eq(200)

      end


      it "does not returns post out of scope " do

         xhr :get, :geolocated, :nwLat => 48, :nwLng => -121,
         :seLat => 46, :seLng => -123
           #ugly need to fix
           parsed_response = JSON.parse(response.body.as_json)
         expect(parsed_response['posts'][0]).to eq nil
         expect(response.status).to eq(200)
      end
      it "returns a post with an image_url" do
         @image = create(:image)
         @post.latitude = '47'
         @post.longitude = '-122'
         @post.update_picture @image
         @post.save! 
         @post.reload
        xhr :get, :geolocated, :nwLat => 48, :nwLng => -123,
        :seLat => 46, :seLng => -121
           parsed_response = JSON.parse(response.body.as_json)
         expect(parsed_response['posts'][0]['id'] ).to eq @post.id
         expect(parsed_response['posts'][0]['image_url'] ).to match(
          /http:\/\/s3-us-west-2.amazonaws.com\/new-stuffmapper-test\/images\/image/)
         expect(response.status).to eq(200)
      end
      it "returns a post with an updated_at" do

        @post.latitude = '47'
        @post.longitude = '-122'
        @post.save!

        xhr :get, :geolocated, :nwLat => 48, :nwLng => -123,
        :seLat => 46, :seLng => -121
  
        parsed_response = JSON.parse(response.body.as_json)
        expect(parsed_response['posts'][0]['id'] ).to eq @post.id
        expect(parsed_response['posts'][0]['updated_at'] ).to_not be nil
        expect(response.status).to eq(200)
      end

      it "returns a post with a category and title" do

        @post.latitude = '47'
        @post.longitude = '-122'
        @post.category = 'Electronics'
        @post.title = 'Old TV'
        @post.save!
        xhr :get, :geolocated, :nwLat => 48, :nwLng => -123,
        :seLat => 46, :seLng => -121

        #xhr :get, :geolocated, :nwLat => 48, :nwLng => -121, :seLat => 46, :seLng => -123
          #ugly need to fix
        parsed_response = JSON.parse(response.body.as_json)
        expect(parsed_response['posts'][0]['id'] ).to eq @post.id
        expect(parsed_response['posts'][0]['title'] ).to eq @post.title
        expect(parsed_response['posts'][0]['category'] ).to eq @post.category
        expect(response.status).to eq(200)
      end


      it "does not return a dibbed item  " do
         @post.latitude = '47'
         @post.longitude = '-122'

         @post.dibbed_until = Time.now + 10.minutes
         @post.save!
         expect(@post.available_to_dib?).to eq(false)
         xhr :get, :geolocated, :nwLat => 48, :nwLng => -121,
         :seLat => 46, :seLng => -123
         parsed_response = JSON.parse(response.body.as_json)
         expect(parsed_response['posts'][0]).to eq nil
         expect(response.status).to eq(200)
      end
    end
  end
  describe "Create", :vcr => vcr_options do
    before do
      @user = create(:user)
    end

    context "without login " do

      it 'should 401' do
        xhr :post, :create
          expect(response.status).to eq(401)
      end
    end

    context "with login and unverified email", :vcr => vcr_options do
      before do
      @user.update_attribute(:verified_email, false)
      shoes = File.read("spec/factories/shoes.png")
      @file = Base64.encode64(shoes)
      end


      it 'should 422 ' do
        sign_in(@user)
        xhr :post, :create, 
        {title:'',  latitude:'47',longitude:'-122' }
        expect(response.status).to eq(422)
      end


    end



    context "with login and verified email", :vcr => vcr_options do
      before do
        shoes = File.read("spec/factories/shoes.png")
        @file = "data:image/png;base64," + Base64.encode64(shoes)
      end


      it 'should 422 with incomplete data' do
        sign_in(@user)
        xhr :post, :create, {title:''}
        expect(JSON.parse(response.body)).to eq(JSON.parse(
          "{\"title\":[\"can't be blank\"],\"longitude\":[\"can't be blank\"],\"latitude\":[\"can't be blank\"]}"))
          expect(response.status).to eq(422)
      end


      it 'should 200 with complete data' do
        sign_in(@user)
        xhr :post, :create, {title:'old tux', latitude:'47',longitude:'-122' }
        expect(response.status).to eq(200)
      end

      it 'should set the post status to loading' do
        sign_in(@user)
        xhr :post, :create, {title:'new tux', latitude:'47',longitude:'-122' }
        expect(response.status).to eq(200)
        expect(Post.last.status).to eq('loading')
      end


      it 'should update a description' do
        sign_in(@user)
        xhr :post, :create, {title:'new tux', image: @file, latitude:'47',
          longitude:'-122', description: 'shoes' }
        expect(Post.last.description).to eq('shoes')
      end

      it 'should update on the curb' do
        sign_in(@user)
        xhr :post,
          :create, {title:'new tux',
            latitude:'47',
            longitude:'-122',
            description: 'shoes',
            on_the_curb: 'true' }
        expect(Post.last.on_the_curb).to eq(true)
      end

      it 'should return data about the post' do
        sign_in(@user)
        xhr :post,
          :create, {title:'new tux',
            latitude:'47',
            longitude:'-122',
            description: 'this is a description for returning data',
            on_the_curb: 'true' }
        parsed_response = JSON.parse(response.body.as_json)
        expect(parsed_response['post']['description'] ).to eq(
          'this is a description for returning data')
      end


    end
  end
  describe "Post update post", :vcr => vcr_options do
    before do
      @user = create(:user)
      @post = create(:post,
        creator_id: @user.id,
        longitude: '-122',
        latitude: '-49' )

    end

    context "without login " do

      it 'should 401' do
        xhr :post, :update, :id => @post.id
          expect(response.status).to eq(401)
      end
    end

    context "with login", :vcr => { :cassette_name => "aws_update",
      :match_requests_on => [:method] } do
      before do
        shoes = File.read("spec/factories/shoes.png")
        @file = "data:image/png;base64," + Base64.encode64(shoes)
      end


      it 'should 200 with complete data' do
        sign_in(@user)
        xhr :post, :update,{id: @post.id , title:'new tux',
          latitude:'47',longitude:'-122' }
        expect(response.status).to eq(200)
      end

      it 'should update a description' do
        sign_in(@user)
        xhr :post, :update, { id: @post.id ,title:'new tux', image: @file, 
          latitude:'47',longitude:'-122', description: 'Update this' }
        expect(Post.find(@post.id).description).to eq('Update this')
      end

      it 'should publish or depublish' do
        expect(@post.published).to eq(true)
        sign_in(@user)
        xhr :post, :update, { id: @post.id , published: false }
        expect(Post.find(@post.id).published).to eq(false)
      end


    end
  end

  describe "Get mystuff", :vcr => vcr_options do


    before do
      @user = create(:user)
      @post = create(:post, creator_id: @user.id, latitude:'47',longitude:'-122'  )
        #create(:post, creator_id: @user.id, latitude:'47',longitude:'-122'  )
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
        expect(parsed_response['posts'][0]['latitude'] ).to eq 47
        expect(parsed_response['posts'][0]['longitude'] ).to eq -122
        expect(response.status).to eq(200)

      end

      it 'should return my stuff with correct attributes' do
        @user3 = create(:user)
        @post.description = "awesome kicks"
        @post.save
        @post.create_new_dib @user3
        sign_in(@user)
        xhr :get, :my_stuff
        parsed_response = JSON.parse(response.body.as_json)
        expect(parsed_response['posts'][0]['description'] ).to eq 'awesome kicks'
        expect(parsed_response['posts'][0]['dibbable'] ).to eq false

      end
      it 'should return my stuff with correct attributes in the future' do
        @user3 = create(:user)
        @post.description = "awesome kicks"
        @post.save
        @post.create_new_dib @user3
        sign_in(@user)
        Timecop.travel(2000)
          xhr :get, :my_stuff
          parsed_response = JSON.parse(response.body.as_json)
          expect(parsed_response['posts'][0]['description'] ).to eq 'awesome kicks'
          expect(parsed_response['posts'][0]['dibbable'] ).to eq true
        Timecop.return
      end

      it 'should return my stuff with a creator username' do

        @post.description = "awesome kicks"
        @post.save
        sign_in(@user)
        xhr :get, :my_stuff
        parsed_response = JSON.parse(response.body.as_json)
        expect(parsed_response['posts'][0]['creator'] ).to eq @user.username

      end

      it 'should return info about dibs' do
        pending
        #Note this may not be used. Probably should have this 
        #type of functionality on the dibs controller
        @user2 = create(:user)
        @post.create_new_dib @user2

        sign_in(@user)
        xhr :get, :my_stuff
        parsed_response = JSON.parse(response.body.as_json)
        first_dib = parsed_response['posts'][0]['dibs'][0]
        expect( first_dib['dibber'] ).to eq @user2.username
        expect( first_dib['conversation_url'] ).to match(
         /^http:\/\/localhost:7654\/user\/chat\/.+$/)

      end
    end
  end
  describe "Get my-dibs", :vcr => vcr_options do


    before do
      @user = create(:user)
      @user2 = create(:user)
      @post = create(:post, creator_id: @user.id, latitude:'47',longitude:'-122'  )
      @post.create_new_dib @user2
      @post.reload
      @user2.reload
        #create(:post, creator_id: @user.id, latitude:'47',longitude:'-122'  )
    end

    context 'without login' do
      it 'should return 401' do
        xhr :get, :my_dibs
          expect(response.status).to eq(401)

      end
    end

    context 'with login' do

      it 'should return 200' do
        sign_in(@user2)
        xhr :get, :my_dibs
          expect(response.status).to eq(200)
      end

      it 'should return my dibs' do
        sign_in(@user2)
        xhr :get, :my_dibs
        parsed_response = JSON.parse(response.body.as_json)
        expect(parsed_response['posts'][0]['latitude']).to eq 47
        expect(parsed_response['posts'][0]['longitude']).to eq -122
        expect(parsed_response['posts'][0]['isCurrentDibber']
            ).to eq true
        expect(parsed_response['posts'][0]['dibbable']
            ).to eq false
        expect(response.status).to eq(200)
      end

    end
  end


  describe "Get show", :vcr => vcr_options do
    before do
      @user = create(:user)
        @post = build(:post,
            creator_id: @user.id,
            latitude: '49',
            longitude: '-122'
            )
        @post.save
    end

    it "should return a 200 response" do

      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
    end

    it "should return the right post" do
      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['post']['id']).to eq(@post.id)
    end
    it "should get an items dibbed status" do
      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['post']['dibbable']).to eq(true)
    end
    it "should get an items dibbed status" do
      @post.dibbed_until = Time.now + 10.minutes
      @post.save!
      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['post']['dibbable']).to eq(false)
    end
    it "should get an items dibbed status change depending on the time" do

      @user3 = create(:user)
      @post.create_new_dib @user3
      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['post']['dibbable']).to eq(false)
      Timecop.travel(1810)
        xhr :get, :show, :id => @post.id
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['post']['dibbable']).to eq(true)
      Timecop.return
    end

    it "should show  a status" do
      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['post']['status']).to eq("new")
    end

    #TODO make new rspec for serializer - this is really only testing the serializer
    it "should show  a status" do
      @user2 = create(:user)
      @post.create_new_dib @user2
      @post.reload 
      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['post']['status']).to eq("dibbed")
      expect(@post.status).to eq('new')
    end

    it "should show a deleted status" do
      @post.update_attribute( :status, 'deleted')
      @post.reload 
      xhr :get, :show, :id => @post.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['post']['status']).to eq("deleted")
      expect(@post.status).to eq('deleted')
    end




  end

  describe "Get search", :vcr => { :cassette_name => "Get_show_post_controller", :match_requests_on => [:method] }do

    before do
      @user = create(:user)
      4.times do |x|
          create(:post,
            creator_id: @user.id,
            latitude: '49',
            longitude: '-122',
            on_the_curb: true
            )
        end
        6.times do |x|
          create(:post,
            creator_id: @user.id,
            latitude: '49',
            longitude: '-122',
            on_the_curb: false
            )
        end
    end

    it "should return a 200 response" do
      xhr :get, :search
      expect(response.status).to eq(200)
    end

    it "should return all local posts" do
      xhr :get, :search, :latitude => '49', :longitude => '-122'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['posts'].length ).to eq(10)
    end
    it "should return only on_the_curb  posts when specified
      " do
      xhr :get, :search, :latitude => '49', :longitude => '-122', :on_the_curb => true
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['posts'].length ).to eq(4)
    end
    it "should not return on_the_curb  posts when specified
      " do
      xhr :get, :search, :latitude => '49', :longitude => '-122', :on_the_curb => false
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['posts'].length ).to eq(6)
    end

  end

  describe "Remove post", :vcr => vcr_options do
    before do
      @user = create(:user)
      @post = create(:post,
        creator_id: @user.id,
        longitude: '-122',
        latitude: '-49' )

    end

    context "without login " do

      it 'should 401' do
        xhr :post, :remove, :id => @post.id
          expect(response.status).to eq(401)
      end
    end

    context "with login", :vcr => { :cassette_name => "aws_update", :match_requests_on => [:method] } do
      before do
        shoes = File.read("spec/factories/shoes.png")
        @file = "data:image/png;base64," + Base64.encode64(shoes)
      end


      it 'should 200 with complete data' do
        sign_in(@user)
        xhr :post, :remove, {id: @post.id}
        expect(response.status).to eq(200)
      end

      it 'should update status' do
        sign_in(@user)
        xhr :post, :remove, {id: @post.id}
        expect(Post.find(@post.id).status).to eq('deleted')
      end
    end
  end

  describe "Remove current dib", :vcr => vcr_options do
    before do
      @user = create(:user)
      @user2 = create(:user)
      @post = create(:post,
        creator_id: @user.id,
        longitude: '-122',
        latitude: '-49' )
      @post.create_new_dib @user2

    end

    context "without login " do

      it 'should 401' do
        xhr :post, :remove_dib, :id => @post.id
          expect(response.status).to eq(401)
      end
    end

    context "with login"  do


      it 'should 200 with complete data' do
        sign_in(@user)
        xhr :post, :remove_dib, {id: @post.id}
        expect(response.status).to eq(200)
      end

      it 'should remove the dibber' do
        sign_in(@user)
        expect(@post.current_dibber).to eq @user2
        xhr :post, :remove_dib, {id: @post.id}
        @post.reload
        expect(@post.current_dibber).to be_nil
      end

      it 'should return information about the post' do
        sign_in(@user)
        expect(@post.current_dibber).to eq @user2
        xhr :post, :remove_dib, {id: @post.id}
        parsed_response = JSON.parse(response.body.as_json)
        @post.reload
        expect(parsed_response['post']['currentDib']
            ).to eq false
        expect(parsed_response['post']['dibbable']
            ).to eq true
        expect(@post.current_dibber).to be_nil
      end
    end
  end


end
