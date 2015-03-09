
require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "Post create" do
    before do

      xhr :post,:create, user: user_var
    end

   
    

    context "When the data is complete" do
      let (:user_var) { {first_name: 'John', last_name: 'Smith', username: 'thing', email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should 200' do
        expect(response.status).to eq(200)
      end

    end

    context "When the data is incomplete" do
      let (:user_var) { {first_name: '', last_name: 'Smith', username: 'thing', email: 'fake@name.com', password: '123456', password_confirmation: '123456', username: 'Superbad'} }

      it 'should 422' do
        expect(response.status).to eq(422)
      end

    end


  end
end