Given(/^that there are (\d+) items on the curb and (\d+) items not on the curb near me\.$/) do |arg1, arg2|
  	VCR.use_cassette('aws_cucumber3', :match_requests_on => [:method] ) do 
		@current_user = create(:user)
   		arg1.to_i.times do |x| 
   			x = (x * 0.001)
   			#map defaults to seattle when called from localhost . This may need to be revisited 
   			post = build(:post,
   			 creator_id: @current_user.id,
   			 latitude: "47.6097",
   			 longitude: (-122.3331 + x).to_s,
   			 description: 'shoes',
   			 on_the_curb: true) 

  			post.save!
  		end
  		arg2.to_i.times do |x| 
   			x = (x * 0.001)
   			#map defaults to seattle when called from localhost . This may need to be revisited 
   			post = build(:post,
   			 creator_id: @current_user.id,
   			 latitude: "47.6097",
   			 longitude: (-122.3331 + x).to_s,
   			 description: 'shoes',
   			 on_the_curb: false) 
  			post.save!
  		end
  	end# express the regexp above with the code you wish you had
end

Then(/^I should see all the items$/) do
  center_map_to_post Post.last
  expect(page.body).to have_selector('.stuff-view', :count => 9 )# express the regexp above with the code you wish you had
end

When(/^I search for only on the curb items$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should only see the on the curb items$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^search for only not on the curb items$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should only see the not on the curb items$/) do
  pending # express the regexp above with the code you wish you had
end
