require 'rails_helper'

RSpec.describe Report, type: :model do
  vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }
  describe "Model creation", :vcr => vcr_options  do 
    before do 
      two_users_post_dib
    end
  	it 'should be attached to a dib' do
      @report = create(:report)
  		@dib.report = @report
      @dib.save
      expect(@report.dib_id ).to eq @dib.id 
      expect(@report.dib ).to eq @dib
  	end

    it 'should define status on an 11 point scale' do
      @report = create(:report, rating: 5)
      @dib.report = @report
      @dib.save
      expect(@report.sentiment).to eq 'neutral'
      @report.update_attribute(:rating, 7 )
      expect(@report.sentiment).to eq 'positive'
      @report.update_attribute(:rating, 0 )
      expect(@report.sentiment).to eq 'negative'
      @report.update_attribute(:rating, 10 )
      expect(@report.sentiment).to eq 'positive'
    end
  end
end
