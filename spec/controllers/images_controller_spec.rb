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
      sign_in(@user)
      xhr :post, :create, {image: fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png')  }

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
end
