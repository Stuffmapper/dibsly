Given(/^that there are some items posted near me and I'm geolocated$/) do
	VCR.use_cassette('aws_cucumber', :match_requests_on => [:method] ) do 
		@user = create(:user)
   		10.times do |x| 
   			x = (x * 0.001)
   			#map defaults to seattle when called from localhost . This may need to be revisited 
   			post = build(:post, creator_id: @user.id, latitude: "47.6097", longitude: (-122.3331 + x).to_s ) 
  			post.save!
  		end
  	end

end


When(/^I visit the home page$/) do
   visit('/')
end

Then(/^I should see a map$/) do
  expect(page).to have_css('.angular-google-map-container')
  find('.angular-google-map-container').click
end

Then(/^I should see some items on the map$/) do

  expect(page).to have_selector('.angular-google-map-marker', :visible => false, :count=> 10 )
  
end

