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

		describe "doesn't allow usernames of different cases" do

			it "changes doesn't save dup usernames" do
				create(:user, username: 'John' )
				user2  = build(:user, username: 'john')
				expect(user2.save).to eq false
			end
		end


    describe "allows user to post if email verified" do
      let(:user) { build(:user, verified_email: false  ) }

      it "defaults to false" do
        expect( user.allowed_to_post_and_dib? ).to eq false
      end

      it "it depends on email verification" do
        user.verified_email = true
        user.save
        expect( user.allowed_to_post_and_dib? ).to eq true
      end
    end
    describe "sends a verification email if email not marked verified before" do
      let(:user) { build(:user, verified_email: false ) }
      it "sends email" do
        allow( user ).to receive(:confirm_email).and_call_original.at_most(2).times

        expect(Notifier).to receive(:email_verification).and_call_original.at_most(2).times

        user.save
        expect( user ).to have_received(:confirm_email)

      end
      it "updates verification token with urlsafe_base64" do
        expect( user.verify_email_token ).to eq nil
        expect(SecureRandom).to receive(:urlsafe_base64).and_call_original
        user.save
        expect( user.verify_email_token ).to_not eq nil
      end

			it " doesn't send an email when a user tries to create a user with the same email" do
				user1 = create(:user)
				user.email = user1.email
				allow( user ).to receive(:send_verification_email).and_call_original
				expect(Notifier).to_not receive(:email_verification).and_call_original
				user.save
				expect(user.save).to eq false
			end
  	end

	 describe "Creates from social media" do

	      it "uses facebook " do
					User.from_omniauth(OmniAuth.config.mock_auth[:facebook],nil)
					expect(User.last.username).to eq('FakeName')
	      end

				it "uses facebook " do
					User.from_omniauth(OmniAuth.config.mock_auth[:google_oauth2],nil)
					expect(User.last.username).to eq('FakeName')
				end

				it "creates usernames when they're take " do
					create(:user, :username => "FakeName")
					User.from_omniauth(OmniAuth.config.mock_auth[:google_oauth2], nil)
					expect(User.count).to eq 2
					expect(User.last.username).to eq('FakeName1')
				end

	    end

  end
