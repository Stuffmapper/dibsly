
require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "Post create" do
    before do
      xhr :post,:create, user: user_var
    end

    context "When the data is complete" do
      let (:user_var) { {first_name: 'John', last_name: 'Smith',  email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should 200' do
        expect(response.status).to eq(200)
      end

    end

    context "When the data is incomplete" do
      let (:user_var) { {first_name: '', last_name: 'Smith', email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should 422' do
        expect(response.status).to eq(422)
      end

    end
    context "When the a user with the same email has been created" do
      let (:user_var) { {first_name: 'John', last_name: 'Smith', email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should ' do
        expect(response.status).to eq(200)
        xhr :post,:create, user: {first_name: 'John', last_name: 'Smith', username: 'thingis', email: 'fake@name.com', password: '123456', password_confirmation: '123456'}
        expect(response.status).to eq(422)
        expect(response.body).to eq("{\"base\":[\"Duplicate username or email\"]}")
      end

    end


  end

  describe "Get confirm_email" do


    context "with valid token" do
      before do
        @current_user = create(:user)
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
        @current_user = create(:user)
        expect(@current_user.verified_email).to eq false
        expect(User).to receive(:find_by_verify_email_token).and_call_original
        xhr :get, :confirm_email, confirmation: 'thiseisafake7788'
        
      end
         
      it 'should 422' do    
        expect(response.status).to eq(422)
      end

      it 'should set the users verified email status' do
        expect(response.body).to eq( "{ message: \"User not Found \"}")
      end

      it 'should reset the token' do
        xhr :get, :confirm_email, confirmation: @current_user.verify_email_token

      end

    end



  end
  
end