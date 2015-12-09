
require 'rails_helper'

RSpec.describe Api::UsersController, :type => :controller do

  describe "POST create" do
    before do
      xhr :post,:create, user: user_var
    end

    context "When the data is complete" do
      let (:user_var) { {first_name: 'John', last_name: 'Smith',  email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should 200' do
        expect(response.status).to eq(200)
      end

    end
   context "With a too short password" do
      let (:user_var) { {first_name: 'John', last_name: 'Smith',  email: 'fake@name.com', password: '12', password_confirmation: '12', username: 'Superbad'} }

      it 'should 422' do
        expect(response.status).to eq(422)
      end

    end
     context "With a blank password" do
      let (:user_var) { {first_name: 'John', last_name: 'Smith',  email: 'fake@name.com', password: '      ', password_confirmation: '      ', username: 'Superbad'} }

      it 'should 422' do
        expect(response.status).to eq(422)
      end

    end

    context "When the data is incomplete" do
      let (:user_var) { {first_name: '', last_name: 'Smith', email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should 422' do
        expect(response.status).to eq(422)
      end

    end
    context "When a user with the same email has already been created" do
      let (:user_var) { {first_name: 'John', last_name: 'Smith', email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should ' do
        expect(response.status).to eq(200)
        xhr :post,:create, user: {first_name: 'John', last_name: 'Smith', username: 'thingis', email: 'fake@name.com', password: '123456', password_confirmation: '123456'}
        expect(response.status).to eq(422)
        expect(response.body).to eq("{\"base\":[\"Duplicate username or email\"]}")
      end

    end


  end
  describe "GET index" do


    context "without login" do
      before do
        @current_user = create(:user,  verified_email: false )
      end

      it 'should 401' do
        xhr :get, :index 
        expect(response.status).to eq(401)
      end

    end

    context "with login" do
      before do
        @current_user = create(:user, email: "b2@email.com", username:"Supe2", id:708)
        sign_in @current_user
      end

      it 'should 200' do
        xhr :get, :index 
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse("{\"user\":{\"email\":\"b2@email.com\",\"id\":708,\"username\":\"Supe2\",\"first_name\":\"John\",\"last_name\":\"Doe\",\"verified_email\":true,\"image_url\":false}}"))
      end
    end
  end

  describe "Get confirm_email" do


    context "with valid token" do
      before do
        @current_user = create(:user,  verified_email: false )
        expect(@current_user.verified_email).to eq false
        expect(User).to receive(:find_by_verify_email_token).and_call_original
        xhr :get, :confirm_email, confirmation: @current_user.verify_email_token
      end

      it 'should 200' do
        expect(response.status).to eq(200)
      end

      it 'should set the users verified email status' do
        xhr :get, :confirm_email, confirmation: @current_user.verify_email_token
        @current_user.reload
        expect(@current_user.verified_email).to eq true
      end

      it 'should reset the token' do
        xhr :get, :confirm_email, confirmation: @current_user.verify_email_token
        @current_user.reload
        expect(@current_user.verify_email_token).to eq nil
      end

    end

    context "with invalid token" do
      before do
        @current_user = create(:user,  verified_email: false )
        expect(@current_user.verified_email).to eq false
        expect(User).to receive(:find_by_verify_email_token).and_call_original
        xhr :get, :confirm_email, confirmation: 'thiseisafake7788'

      end

      it 'should 422' do
        expect(response.status).to eq(422)
      end

      it 'should set the users verified email status' do
        expect(response.body).to eq( "{\"message\":\"User not Found \"}")
      end

      it 'should reset the token' do
        xhr :get, :confirm_email, confirmation: @current_user.verify_email_token

      end

    end

  end
  describe "Post update" do
    before do
      @current_user = create(:user )
      @other_user = create(:user )
    end

    context "without login" do
      it 'should 422' do
        xhr :post, :update, id:  @current_user.id, user:  { first_name: 'NewName', last_name: 'NewLastName' }
        expect(response.status).to eq(401)
      end
    end

    context "with login" do
      it 'should 200' do
        sign_in @current_user
        xhr :post, :update, id:  @current_user.id, user: { first_name: 'NewName', last_name: 'NewLastName' }
        expect(response.status).to eq(200)
      end

      it 'should 422 with the wrong user' do
        expect(@other_user.first_name).to_not eq 'NewName'
        sign_in @current_user
        xhr :post, :update, id:  @other_user.id
        expect(response.status).to eq(401)
        @other_user.reload
        expect(@other_user.first_name).to_not eq 'NewName'
      end

      it 'should update the user' do
        sign_in @current_user
        xhr :post, :update, id:  @current_user.id, user: { first_name: 'NewName', last_name: 'NewLastName' }
        expect(response.status).to eq(200)
        @current_user.reload
        expect(@current_user.first_name).to eq 'NewName'
      end
      
      it 'should not work with the a duplicate username' do
        sign_in @current_user
        xhr :post, :update, id:  @current_user.id, user: { first_name: 'NewName',
           last_name: 'NewLastName',
           username: @other_user.username}
        expect(response.status).to eq(422)
        @current_user.reload
        expect(@current_user.first_name).to_not eq 'NewName'
        expect(@current_user.first_name).to_not eq  @other_user.username
      end



    end
  end
end
