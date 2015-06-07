module AuthenticationHelpers

  module Controller
	  def sign_in(user)
	    controller.stub(:current_user).and_return(user)
	    controller.stub(:user_id).and_return(user.id)
	  end

	  def two_users_post_dib
	  	@post = build(:post)
  		@user = create(:user)
  		@user2 = create(:user)
  		@user.posts << @post 
  		@dib = @post.create_new_dib @user2
	  end

	end

 module FakeEnvironment

	  def two_users_post_dib
	  	@post = build(:post)
  		@user = create(:user)
  		@user2 = create(:user)
  		@user.posts << @post 
  		@dib = @post.create_new_dib @user2
	  end

	end


end
