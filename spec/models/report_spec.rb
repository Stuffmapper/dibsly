require 'rails_helper'

RSpec.describe Report, type: :model do
  vcr_options = { :cassette_name => "aws", :match_requests_on => [:method] }
  describe "Model creation", :vcr => vcr_options  do 
  	it 'should be ok' do

  		@post = build(:post)
  		@user = create(:user)
  		@user2 = create(:user)
  		@user.posts << @post 
  		@dib = @post.create_new_dib @user2
  		@dib.report = Report.create

  	end
  end
end
