require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe "Post create" do
    before do
      user = create(:user, :username => 'Superbad' )
      xhr :post, :create, format: :json, username: username, password: password
    end    

    context "with correct name " do
      let (:username) {'Superbad'}
      let (:password) {'123456'}

      it 'should 200' do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['user']).to eq('Superbad')
      end
    end

    context "with incorrect name " do
      let (:username) {'Superbland'}
      let (:password) {'123456'}
      it 'should 422' do
        expect(response.status).to eq(422)

      end
    end

  end

  describe "Get Log out" do 
    it "should be successful" do 
      
      xhr :get, :destroy, format: :json
      expect(response.status).to eq(200)
    end
  end

  describe "Get check user" do
    before do
      user = create(:user, :username => 'Superbad')
      xhr :post, :create, format: :json, username: 'Superbad', password: '123456'
    end

    context "user logged in " do 
      it 'should 200' do
        xhr :get, :check
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['user']).to eq('Superbad')
      end
    end

    context "user logged out " do
      it 'should 401' do
        xhr :get, :destroy, format: :json
        xhr :get, :check
        expect(response.status).to eq(401)
      end
    end

  end   
end