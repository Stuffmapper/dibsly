require 'rails_helper'

RSpec.describe Image, type: :model do
  vcr_options = { :cassette_name => "aws_image _model", :match_requests_on => [:method] }

  describe "Model creation", :vcr => vcr_options  do
    it "should require an image " do
      image = Image.create
      expect(image.save).to eq false
      image.image = fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png')
      expect(image.save).to eq true

    end

    it "should require an image in an image format " do
      image = Image.create
      expect(image.save).to eq false
      image.image = fixture_file_upload(Rails.root.join("spec/factories/shoes.txt"), 'image/png')
      expect(image.save).to eq false
    end
  end

end
