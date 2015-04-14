require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do


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
				expect{ post :create, email: user.email }.to change( ActionMailer::Base.deliveries, :size )

			end 
			it "sets the flash success message " do 
				post :create, email: user.email 
				expect(flash[:success]).to match(/check your email/)
			end

		end
		context "with no user found" do 
			it "renders the new page " do 
				#returns an error
			end

		end
	end

	describe "GET edit" do 
			context "with a valid password_reset_token " do 
				let(:user) { create(:user )} 
				before { user.generate_password_reset_token! }

				it "assigns a user @user" do 
					get :edit, id: user.password_reset_token
					expect(assigns(:user)).to eq(user)
				end
			end

			context "with a no password_reset_token " do 
				it "renders the 404  " do 
					get :edit, id: 'notfound'
					expect(response.status).to eq(404)
					expect(response).to render_template(file: "#{Rails.root}/public/404.html")
				end

			end
		end

		describe "PATCH update " do 
			context "with not token found " do 
				it "returs 401" do 
					patch :update, id: 'notfound', user: {password: 'fake123', password_confirmation: 'fake123' }
					expect(response).to render_template('edit')	
					#change to resource not found		
				end
			end

			context "with a valid token" do 
				let(:user) { create(:user)}
				before { user.generate_password_reset_token! }

				it "updates the user's password" do 

					digest = user.password_digest
					patch :update, id: user.password_reset_token ,
					user: {password: 'Sofake123', password_confirmation: 'Sofake123' }
					user.reload 
					expect(user.password_digest).to_not eq(digest)
					 
					
				end

				it "clears the password_reset_token " do 
					patch :update, id: user.password_reset_token ,
					user: {password: 'Sofake123', password_confirmation: 'Sofake123' }
					user.reload 
					expect(user.password_reset_token).to be_blank

				
				end

			end

		end




end

