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


    it "should be not be in effect thirty minutes from now" do
       @post.create_new_dib(@user2)
       expect(@post.available_to_dib? ).to eq false
       Timecop.travel(1802)
       sleep(1)
       expect(@post.available_to_dib? ).to eq true
       Timecop.return
    end

    it "should set the post status to dibbed when the dibber sends a message " do
       @dib = @post.create_new_dib(@user2)
       expect(@post.status ).to eq 'new'
       @dib.contact_other_party(@user2, 'this is the body')
       Timecop.travel(1802)
       sleep(1)
       @post.reload
       expect(@post.available_to_dib? ).to eq false
       expect(@post.status ).to eq 'dibbed'
       Timecop.return
    end

    it "should not set the post status to dibbed when the dibber sends a message after undibbing " do
       @dib = @post.create_new_dib(@user2)
       expect(@post.status ).to eq 'new'
       @dib.contact_other_party(@user2, 'this is the body')
       Timecop.travel(1802)
       sleep(1)
       @post.reload
       @post.remove_current_dib
       expect(@post.status ).to eq 'new'
       @dib.contact_other_party(@user2, 'this is the body')
       @post.reload
       expect(@post.available_to_dib? ).to eq true
       expect(@post.status ).to eq 'new'
       Timecop.return
    end

    it "should not set the post status to dibbed when the poster sends a message " do
       @dib = @post.create_new_dib(@user2)
       expect(@post.status ).to eq 'new'
       @dib.contact_other_party(@user, 'this is the body')
       Timecop.travel(1802)
       sleep(1)
       @post.reload
       expect(@post.available_to_dib? ).to eq true
       expect(@post.status ).to eq 'new'
       Timecop.return
    end



  end

end
