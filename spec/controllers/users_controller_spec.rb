
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
end