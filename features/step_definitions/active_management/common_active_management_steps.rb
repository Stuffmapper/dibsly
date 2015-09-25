#STEPS COMMON TO THE ACTIVE MANAGEMENT FOLDER
#IF YOU ARE GOING TO USE THESE IN OTHER LOCATIONS,
#PLEASE MOVE THEM TO COMMON STEPS


Given(/^I'm a registered user I've posted some shoes that Jack has dibbed and Jill is also a registered user\.$/) do

  VCR.use_cassette('active_manage_1', :match_requests_on => [:method] ) do
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @user_jill = create(:user, :username => "Jill")
    @shoes = build(:post, creator_id: @current_user.id, latitude: 47, longitude: -122 , description: 'shoes' )
    @shoes.save!
  end
  @shoes.create_new_dib( @user_jack)
  @shoes.update_attribute(:status, 'new')

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

Then(/^I should not be able to see "(.*?)" as the current dibber\.$/) do |arg1|
  expect(page).to_not have_text("Dibbed by: " + arg1)
end


Then(/^Jill should be able to see the item on the map and dib the item\.$/) do
  expect(Dib.count).to eq 1
  #expect(@shoes.available_to_dib?).to eq true
  click_link 'Sign Out'
  sign_in @user_jill
  center_map_to_post @shoes
  click_link "Get Stuff"
  click_button 'Details'
  expect(page).to have_text 'shoes'
  first(:button, 'Dib').click
  sleep(6)
  expect(Dib.count).to eq 2
  expect(@user_jill.dibs.first.post).to eq @shoes
  @shoes.reload
  expect(@shoes.available_to_dib?).to eq false
  click_link 'Sign Out'

end

Then(/^I should be able to see "(.*?)" as the current dibber\.$/) do |arg1|
  sign_in @current_user
  click_link 'My Stuff'
  sleep(4)
  expect(page).to have_text("Dibbed by: " + arg1)
end

When(/^I mark as gone and select "(.*?)"$/) do |arg1|
  select arg1, from: 'goneReason'
  click_button 'Update'
end


Then(/^It should not be on the map and Jill should not be able to dib it\.$/) do
  center_map_to_post @shoes
  click_link 'Get Stuff'
  expect(page).to_not have_text 'Details'
  @shoes.reload
  expect(@shoes.status).to eq "gone"
  visit @shoes.permalink
end


When(/^the edit button shouldn't be viewable$/) do
  sign_in @current_user
  visit @shoes.permalink
  expect(page).to_not have_text "Edit"
end

When(/^it should be archived$/) do
  pending
  click_link 'My Stuff'
  clink_link 'Posts'
  within('.archived') do
    expect(page).to have_text (@post.title)
  end
end

When(/^the status should be in the details$/) do
  visit @shoes.permalink
  expect(page).to have_text 'This item is gone'
end
