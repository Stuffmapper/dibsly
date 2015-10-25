require 'rails_helper'
require "base64"

RSpec.describe Api::ImagesController, type: :controller do
  vcr_options = { :cassette_name => "aws_image_controller", :match_requests_on => [:method] }

  context "without login ", :vcr => vcr_options do

    before do
      shoes = File.read("spec/factories/shoes.png")
      @file = "data:image/png;base64," + Base64.encode64(shoes)
    end

    it 'should 422 with complete data' do
      xhr :post, :create, { image: @file  }
      expect(response.status).to eq(401)
    end
  end

  context "with login ", :vcr => vcr_options do
    before do
      shoes = File.read("spec/factories/shoes.png")
      @file = "data:image/png;base64," + Base64.encode64(shoes)
      @user = create(:user)
      @post = create(:post, creator_id: @user.id)
      sign_in(@user)
      xhr :post, :create, {image: fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png'),
      type: 'post', id: @post.id  }
    end

    it 'should 200 with complete data' do
      expect(response.status).to eq(200)
    end

    it 'should create an image' do
      expect(response.status).to eq(200)
      expect(Image.count).to eq 1
    end
    it 'should return the image data 'do
      image = JSON.parse(response.body)['image']
      expect(image['thumbnail']).to eq Image.last.image.url(:thumbnail)
      expect(image['id']).to eq Image.last.id
    end


  end
  context "for a post object ", :vcr => vcr_options do
    before do
      shoes = File.read("spec/factories/shoes.png")
      @user = create(:user)
      @post = create(:post, creator_id: @user.id)
      sign_in(@user)


    end
    it 'should 200 with complete data' do
      xhr :post, :create, {image: fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png'),
      type: 'post', id: @post.id  }
      expect(response.status).to eq(200)
    end
    it 'should add an image to @post' do
       xhr :post, :create, {image: fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png'),
      type: 'post', id: @post.id  }
      @post.reload
      expect(@post.pictures.first).to eq Image.last
    end

    it 'shouldn\'t add an image for the wrong user 'do
      @user2 = create(:user)
      sign_in(@user2)
      xhr :post, :create, {image: fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png'),
      type: 'post', id: @post.id  }
      @post.reload
      expect(@post.pictures).to eq []
    end


  end
end
