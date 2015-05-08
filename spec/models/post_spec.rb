require 'rails_helper'

RSpec.describe Post, :type => :model do
  vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }
  describe "Model creation", :vcr => vcr_options  do 
  	before do
  		  @user = create(:user)
        @user2 = create(:user, {username: 'user2', email: 'anotherfake@email.com'})
        @post = create(:post, creator_id: @user.id, longitude: 0, latitude:0  ) 	
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
   it 'should be dibbable' do
    @post.create_new_dib(@user2)

    end
    it 'should create a conversation' do
      expect(@post.conversation).to_not eq nil

    end
  it 'should be available' do
    expect(@post.available_to_dib?).to eq(true)


  end

end
  describe "Model Dibbing", :vcr => vcr_options  do 
    before do
        @user = create(:user)
        @user2 = create(:user, {username: 'user2', email: 'anotherfake@email.com'})
        @post = create(:post, creator_id: @user.id, longitude: 0, latitude:0  )   
    end

    it "should be able to be dibbed" do 

      @post.create_new_dib @user2
      expect(@post.available_to_dib?).to eq false
      expect(@post.dibber_id).to eq @user2.id

    end

    it "should be able to be unDibbed" do 
      
      @post.create_new_dib @user2
      expect(@post.available_to_dib?).to eq false
      @post.remove_current_dib
      expect(@post.dibber_id).to eq nil
      expect(@post.available_to_dib?).to eq true
  
    end


end


end