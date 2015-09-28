#STEPS COMMON TO THE ACTIVE MANAGEMENT FOLDER
#IF YOU ARE GOING TO USE THESE IN OTHER LOCATIONS,
#PLEASE MOVE THEM TO COMMON STEPS


Given(/^I'm a registered user I've posted some shoes that Jack has dibbed and Jill is also a registered user\.$/) do

  VCR.use_cassette('active_manage_1', :match_requests_on => [:method] ) do
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @user_jill = create(:user, :username => "Jill")
    @shoes = build(:post, creator_id: @current_user.id, latitude: 47.6097, longitude: -122.3331, description: 'shoes' )
    @shoes.save!
  end
  @shoes.create_new_dib( @user_jack)
end


Then(/^I should not be able to see "(.*?)" as the current dibber\.$/) do |arg1|
  expect(page).to_not have_text("Dibbed by: " + arg1)
end



Then(/^I should be able to see "(.*?)" as the current dibber\.$/) do |arg1|
  sign_in @current_user
  click_link 'My Stuff'
  sleep(4)
  expect(page).to have_text("Dibbed by: " + arg1)
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
