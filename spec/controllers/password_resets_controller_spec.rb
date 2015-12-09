require 'rails_helper'

RSpec.describe Api::PasswordResetsController, type: :controller do


	describe "POST create" do

		context "with a valid user and email" do
			let(:user) { create(:user)}

			it "finds the user " do
				expect(User).to receive(:find_by).with(email: user.email).and_return(user)
				xhr :get, :create, email: user.email
			end


			it "generates a new password reset token" do
				expect{ xhr :post, :create, email: user.email; user.reload }.to change{ user.password_reset_token }
			end

			it "sends a password reset email " do
				expect{ post :create, email: user.email }.to change( MandrillMailer::deliveries, :size )

			end
			it "sends a message via Json " do
				xhr :post, :create, email: user.email
				expect(JSON.parse(response.body)["message"]).to match(/Reset instructions sent! Check your email!/)
			end

		end
		context "with no user found" do
			it "renders the new page " do
				xhr :post, :create, email: 'junk'
				expect(JSON.parse(response.body)["message"]).to match(/User not found/)
			end

		end

		context "without an email entered" do
			it "renders the new page " do
				xhr :post, :create
				expect(JSON.parse(response.body)["message"]).to match(/User not found/)
			end

		end
	end

	describe "GET edit" do
			context "with a valid password_reset_token " do
				let(:user) { create(:user )}
				before { user.generate_password_reset_token! }

				it "assigns a user @user" do
					xhr :get, :edit, id: user.password_reset_token
					expect(assigns(:user)).to eq(user)
				end
			end

			context "with a no password_reset_token " do
				it "sends a 404 response  " do
					xhr :get, :edit, id: 'notfound'
					expect(response.status).to eq(404)
					expect(JSON.parse(response.body)["message"]).to match(/User not found/)

				end

			end
		end

		describe "Post update " do
			context "with not token found " do
				it "returns 401" do
					xhr :post, :update, id: 'notfound', user: {password: 'fake123', password_confirmation: 'fake123' }
					expect(response.status).to eq(401)
					#change to resource not found
				end
			end

			context "with a valid token" do
				let(:user) { create(:user)}
				before { user.generate_password_reset_token! }

				it "updates the user's password" do

					digest = user.password_digest
					xhr :post, :update, id: user.password_reset_token ,
					user: {password: 'Sofake123', password_confirmation: 'Sofake123' }
					user.reload
					expect(user.password_digest ).to_not eq(digest)


				end

				it "doesn't work with small passwords" do

					digest = user.password_digest
					xhr :post, :update, id: user.password_reset_token ,
					user: {password: '1', password_confirmation: '1' }
					user.reload
					expect(user.password_digest ).to eq(digest)


				end

				it "clears the password_reset_token " do
					xhr :post, :update, id: user.password_reset_token ,
					user: {password: 'Sofake123', password_confirmation: 'Sofake123' }
					user.reload
					expect(user.password_reset_token).to be_blank


				end

			end

		end




end
