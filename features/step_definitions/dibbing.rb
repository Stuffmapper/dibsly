Given(/^I'm a registered user and Jack has posted some shoes and Jill is another registered user$/) do
  VCR.use_cassette('aws_cucumber3', :match_requests_on => [:method] ) do 
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @user_jill = create(:user, :username => "Jill") 
    @shoes = build(:post, creator_id: @user_jack.id, latitude: "47", longitude: '-122', description: 'shoes' ) 
    @shoes.save!
  end
end


When(/^I log in and visit the map location where the shoes are\.$/) do
  visit('/')
  sign_in(@current_user)
  #bad practice but working this will have to change if we switch to different directive
  execute_script("var myLatLng = new google.maps.LatLng(#{@shoes.latitude}, #{@shoes.longitude});
    var map = angular.element('map').scope().map;
    map.panTo(myLatLng);
    map.setZoom(16);")
  sleep(1)
  
end

Then(/^I should see the shoes in the menu$/)  do
  within('#stuffmapper-menu') do 
    expect(page).to have_text("shoes") 
  end
end

Then(/^I should not see the shoes in the menu$/)  do
  within('#stuffmapper-menu') do 
 
    expect(page).to_not have_text("shoes") 
  end
end

When(/^I hit dib$/) do
  click_button('Dib')
 end

Then(/^I should not see the shoes in the menu when I visit the map\.$/) do
  visit('/')
  execute_script("var myLatLng = new google.maps.LatLng(#{@shoes.latitude}, #{@shoes.longitude});
  var map = angular.element('map').scope().map;
  map.panTo(myLatLng);
  map.setZoom(16);")
  sleep(1)
  within('#stuffmapper-menu') do 
    expect(page).to_not have_text("shoes") 
  end 
end

Then(/^Jack should have been notified of my dib\.$/) do
  
  open_email(@user_jack.email)

  expect(current_email.body).to have_text( "dibbed your stuff"   )

end

When(/^Jill has dibbed Jack's shoes$/) do
  @shoes.create_new_dib(@user_jill ) 
end



When(/^I visit the shoes permalink page$/) do
  visit('/post/' + @shoes.id.to_s ) 
end

Then(/^I should not be able to dib the item\.$/) do
  sleep(3)
  expect(page).to_not have_text 'Dib'# express the regexp above with the code you wish you had
end

Given(/^I'm logged out$/) do
   # express the regexp above with the code you wish you had
end
Then(/^I should not be able to dib the item by pressing dib\.$/) do
  click_button('Dib')
  expect(@shoes.available_to_dib?).to eq true # express the regexp above with the code you wish you had
end

##UNDIB

Given(/^I'm a registered user and I've dibbed Jack's shoes$/) do
  VCR.use_cassette('aws_cucumber3', :match_requests_on => [:method] ) do 
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @shoes = build(:post, creator_id: @user_jack.id, latitude: "47", longitude: '-122', description: 'shoes' ) 
    @shoes.save!
    @shoes.create_new_dib(@current_user ) 
  end
end

When(/^I go to my stuff and undibs Jack's shoes$/) do
  click_link('My Stuff')
  within('#mystuff-' + @shoes.id.to_s ) do
    click_button('unDib')
  end
end
Then(/^I should not see the shoes in the get stuff menu$/) do
  click_link('Get Stuff')
  within('#get-stuff') do 
    expect(page).to_not have_text("shoes") 
  end  
end
Then(/^I should see the shoes in the get stuff  menu$/) do
  click_link('Get Stuff')
  within('#get-stuff') do 
    expect(page).to have_text("shoes") 
  end  

end



When(/^I visit the map location where the shoes are\.$/) do
    execute_script("var myLatLng = new google.maps.LatLng(#{@shoes.latitude}, #{@shoes.longitude});
  var map = angular.element('map').scope().map;
  map.panTo(myLatLng);
  map.setZoom(16);")
    sleep(1)
end

Then(/^Jack should have been notified of my unDib\.$/) do
  open_email(@user_jack.email)
  expect(current_email.body).to have_text(   'has undibbed your' )

end

### EMAIL CONFIRMATION

Given(/^I've received an email\.$/) do
  open_email(@current_user.email)
  expect(current_email.body).to have_text( @current_user.first_name )
end

Then(/^is should explain information about dibs$/) do
  expect(current_email.body).to have_text("thirty minutes to initiate contact with the lister" )
end

Then(/^if I follow the link in the email$/) do
  visit('/')
  sign_in(@current_user)
  current_email.click_link "http://"
end

Then(/^I should be in the in\-app chat$/) do
  sleep(3)
  expect(page.body).to have_text('Dibber Chat')
end