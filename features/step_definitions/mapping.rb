Given(/^that there are some items posted near me and I'm geolocated$/) do

   page.set_rack_session(:lat => 47.547240099999996)
   page.set_rack_session(:lon => -122.38658799999999)
   10.times {|x| Post.create(:latitude => 47.547240099999996, :longitude => -122.38658799999999, :image_url => x )}
   

end


When(/^I visit the home page$/) do
   visit('/')
end

Then(/^I should see a map$/) do
  expect(page).to have_css('ui-gmap-google-map')
end

Then(/^I should see some items on the map$/) do
  pending
  #to container 10 markers 
end

