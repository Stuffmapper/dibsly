require 'rails_helper'

RSpec.describe Image, type: :model do
  vcr_options = { :cassette_name => "aws_image_model", :match_requests_on => [:method] }

  describe "Model creation", :vcr => vcr_options  do
    it "should require an image " do
      image = build(:image, image: nil)
      expect(image.save).to eq false
      image.image = fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png')
      expect(image.save).to eq true

    end

    it "should require an image in an image format " do
      image = build(:image, image: nil)
      expect(image.save).to eq false
      image.image = fixture_file_upload(Rails.root.join("spec/factories/shoes.txt"), 'image/png')
      expect(image.save).to eq false
    end
  end

  describe "Polymorphic status", :vcr => { :cassette_name => "Polymorphic_status", :match_requests_on => [:method] }  do
    before do 
      @image = create(:image)
      @user = create(:user)
    end
    
    it "attaches itself to a post" do
      expect(@image.imageable_type).to eq nil
      expect(@image.imageable_id).to eq nil
      @post = create(:post, creator_id: @user.id )
      expect(@post.pictures).to eq []
      @post.pictures << @image
      @post.save!
      @post.reload
      expect(@image.imageable_type).to eq 'Post'
      expect(@image.imageable_id).to eq @post.id
    end

    it "attaches itself to a user" do
      expect(@image.imageable_type).to eq nil
      expect(@image.imageable_id).to eq nil
      expect(@user.picture).to eq nil
      @user.picture = @image
      @user.save
      @user.reload
      expect(@image.imageable_type).to eq 'User'
      expect(@image.imageable_id).to eq @user.id
    end

  end

end
