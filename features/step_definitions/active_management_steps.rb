
Given(/^I'm a registered user I've posted some shoes that Jack has dibbed and Jill is also a registered user\.$/) do

  VCR.use_cassette('aws_cucumber3', :match_requests_on => [:method] ) do 
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @user_jill = create(:user, :username => "Jill") 
    @shoes = build(:post, creator_id: @current_user.id, latitude: "47", longitude: '-122', description: 'shoes' ) 
    @shoes.save!
  end
  @shoes.create_new_dib( @user_jack) 

end

When(/^I manage dibs for shoes in My Stuff$/) do
  visit '/'
  sign_in @current_user
  click_link('My Stuff')
  expect(page).to have_text 'My Posts'
end

Then(/^I should see "(.*?)" as the current dibber$/) do |arg1|
   click_link('My Stuff')
  expect(page).to have_text("Dibbed by: " + arg1)
end

When(/^I remove current dibber and select "(.*?)"$/) do |arg1|
  select arg1, from: 'undibReason'
  click_button 'Remove'
end

Then(/^Jill should be able to see the item on the map and dib the item\.$/) do
  expect(Dib.count).to eq 1 
  click_link 'Sign Out'
  sign_in @user_jill
  center_map_to_post @shoes
  click_link 'Get Stuff' 
  expect(page).to have_text 'shoes'
  click_button 'Dib'
  expect(Dib.count).to eq 2 
  expect(user_jill.dibs.first.post).to eq @shoes

end

When(/^I mark as gone and select "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the shoes in the old posts section$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^It should not be on the map and Jill should not be able to dib it\.$/) do
  pending # express the regexp above with the code you wish you had
end