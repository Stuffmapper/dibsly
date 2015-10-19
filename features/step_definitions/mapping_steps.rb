Given(/^that there are some items posted near me and I'm geolocated$/) do
	VCR.use_cassette('mapping1', :match_requests_on => [:method] ) do 
		@user = create(:user)
   		10.times do |x|
   			x = (x * 0.001)
   			#map defaults to seattle when called from localhost . This may need to be revisited
   			post = build(:post, creator_id: @user.id, latitude: "47.6097", longitude: (-122.3331 + x).to_s, description: 'shoes' )
  			post.save!
        post.update_attribute(:image_url, '/assets/pin.svg' )
  		end
  	end

end


When(/^I visit the home page$/) do
  center_map_to_post Post.last
  visit('/')

end

Then(/^I should see a map$/) do
  expect(page.body).to have_selector('#google-map')

end

Then(/^I should see some items on the map$/) do
  #driver.findElement(By.cssSelector("div[title='shoes']")).click()

  expect(page.body).to have_selector(".stuff-md-image", :count=> 10 )

end
