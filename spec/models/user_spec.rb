require 'rails_helper'

RSpec.describe User, :type => :model do
	 let(:valid_attributes) {
      {
       first_name:"Jason",
       last_name: "Patterson",
       email: "name@somethin.com",
       username: 'thing',
       password: "j1235",
       password_confirmation: "j1235"
      }
    }


    describe "#generate_password_reset_token!" do 
      let(:user) { create(:user) }
      it "changes the password_reset_token attribute" do 
        expect{ user.generate_password_reset_token!}.to change{ user.password_reset_token }  
      end

      it "calls SecureRandom.urlsafe_base64 to generate the password_rest_token" do 
        expect(SecureRandom).to receive(:urlsafe_base64)
        user.generate_password_reset_token!
      end
    end
    describe "downcases email and username" do 
      let(:user) { create(:user, email: 'CamElcase@email.com' ) }

      it "changes an email" do 
        expect( user.email ).to eq 'camelcase@email.com' 
      end
    end

end
