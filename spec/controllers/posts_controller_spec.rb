require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

	describe "Get index" do
		before do
		VCR.use_cassette('aws') do
			#Paperclip::Attachment.any_instance.stub(:save_attached_files).and_return(true)
			user = create(:user)
			post = create(:post, creator_id: user.id )
		end
		end
		context "when there are far and near posts " do

			it "returns posts" do
			end

			it "only returns post nearby " do
			end
		end
	end
end
