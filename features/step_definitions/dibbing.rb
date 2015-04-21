Given(/^I'm a registered user and Jack has posted some shoes and Jill is another registered user$/) do
  VCR.use_cassette('aws_cucumber3', :match_requests_on => [:method] ) do 
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @user_jill = create(:user, :username => "Jill") 
    @shoes = build(:post, creator_id: @user_jack.id, latitude: "47", longitude: '-122', description: 'shoes' ) 
    @shoes.save!
  end
end


When(/^log in and I visit the map location where the shoes are\.$/) do
  visit('/')
  sign_in(@current_user)
  #bad practice but working this will have to change if we switch to different directive
  execute_script("var myLatLng = new google.maps.LatLng(#{@shoes.latitude}, #{@shoes.longitude});
    var map = angular.element('map').scope().map;
    map.panTo(myLatLng);
    map.setZoom(16);")
  sleep(1)
  
end

Then(/^I should see the shoes in the menu$/) do
  within('#stuffmapper-menu') do 
    expect(page).to have_text("shoes") 
  end
end

When(/^I hit dib$/) do
  click_button('Dib')
 end

Then(/^I should not see the shoes in the menu when I visit the map\.$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^Jack should have been notified of my dib\.$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^Jill has dibbed Jack's shoes$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I log in and visit the map location where the shoes are\.$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not see the shoes$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I visit the shoes permalink page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not be able to dib the item\.$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I log out$/) do
  pending # express the regexp above with the code you wish you had
end