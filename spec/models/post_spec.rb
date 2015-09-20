require 'rails_helper'

RSpec.describe Post, :type => :model do
  vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }

  describe "Model creation", :vcr => vcr_options  do 
  	before do
  		  @user = create(:user)
        @user2 = create(:user, {username: 'user2', email: 'anotherfake@email.com'})
        @post = create(:post, creator_id: @user.id, longitude: 0, latitude:0, status:'loading'  ) 	
    end

    it "should be set as loading" do 
      expect(@post.status).to eq('loading')
    end

  	it "should have the correct attributes" do 
      expect(@post.latitude).to eq(0)
  	end
    it "should send a message" do 
      @post.send_message_to_creator(@user2, 'this is a message', 'this is another thing')
      conversation =  @user.mailbox.inbox.last
      receipts = conversation.receipts_for @user
      receipts.each {|receipt| expect(receipt.message.body).to eq('this is a message') }
    end
    it 'should be dibbable after set new' do
      @post.create_new_dib(@user2)
      expect(@post.current_dibber).to eq nil
      @post.update_attribute(:status ,'new')
      @post.reload
      expect(@post.status).to eq 'new'
      expect(@post.available_to_dib?).to eq true
      @post.create_new_dib(@user2)
      expect(@post.current_dibber).to eq @user2

    end
    it 'should create a conversation' do
      expect(@post.conversation).to_not eq nil

    end
    it 'should be available after being set to new' do
      expect(@post.available_to_dib?).to eq(false)
      @post.update_attributes(:status => 'new')
      @post.reload
      expect(@post.available_to_dib?).to eq(true)
    end

  end
  describe "Post.create_new_dib", :vcr => vcr_options  do

    before do
      @user = create(:user)
      @user2 = create(:user, {username: 'user2', email: 'anotherfake@email.com'})
      @post = create(:post, creator_id: @user.id, longitude: 0, latitude:0, status: 'new'  )   
    end

    it "should return a dib" do 
      dib = @post.create_new_dib @user2
      expect(dib.class.name).to eq "Dib"
      expect(@post.current_dibber).to eq @user2
    end

    it "should not add a current dibber if the post is unavailable" do 
      @post.update_attribute(:status, 'loading')
      @post.reload

      dib = @post.create_new_dib @user2
      expect(@post.current_dibber).to_not eq @user2
    end

  end

  describe "Model Dibbing", :vcr => vcr_options  do 
    before do
        @user = create(:user)
        @user2 = create(:user, {username: 'user2', email: 'anotherfake@email.com'})
        @post = create(:post, creator_id: @user.id, longitude: 0, latitude:0, status: 'new'  )   
    end

    it "should be able to be dibbed" do 
      @post.create_new_dib @user2
      expect(@post.available_to_dib?).to eq false
      expect(@post.current_dibber).to eq @user2
    end

    it "should be able to be unDibbed" do 
      
      @post.create_new_dib @user2
      expect(@post.available_to_dib?).to eq false
      @post.remove_current_dib
      expect(@post.current_dibber).to eq nil
      expect(@post.available_to_dib?).to eq true
  
    end
    
    it "should be able to set dibbed status" do 
       @post.create_new_dib(@user2)
       expect(@post.available_to_dib? ).to eq false
       @post.make_dib_permanent
       Timecop.travel(1802)
       sleep(1)
       expect(@post.available_to_dib? ).to eq false
       Timecop.return
    end
  end
end