require 'rails_helper'

RSpec.describe Dib, :type => :model do
  vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }
  describe "Model creation", :vcr => vcr_options  do 
  	before do
  		  @user = create(:user)
        @user2 = create(:user, {username: 'user2', email: 'anotherfake@email.com'})
        @post = create(:post, creator_id: @user.id, longitude: 0, latitude:0  ) 	
    end

    it "should be created from a post" do 
       expect(Dib.count).to eq 0
       @post.create_new_dib(@user2)
       expect(Dib.count).to eq 1
    end

    it "should have one conversation" do 
      
       @post.create_new_dib(@user2)
       expect(Dib.last.conversation.class ).to eq Mailboxer::Conversation
    end


  end

end