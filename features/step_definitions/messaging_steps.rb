And(/^that "(.*?)"  has  posted shoes and "(.*?)" has dibbed them\.$/) do |arg1, arg2|
 VCR.use_cassette('aws2_cucumber', :match_requests_on => [:method] ) do
  user1 = User.find_by_username(arg1)
  user2 = User.find_by_username(arg2)

  post = build(:post, creator_id: user1.id, latitude: "47.6097", longitude: '-122.3331'  )
  post.save!
  post.create_new_dib(user2)
 end
end

When(/^"(.*?)" logs in$/) do |arg1|
  user1 = User.find_by_username(arg1)
  visit('/')
  sign_in user1

end

Then(/^"(.*?)" should be visible in the inbox$/) do |arg1|
  visit("/#/menu/mystuff")
  sleep 2
  find('.myPost-button').click
  sleep(1)

  expect(page).to have_text(arg1)
end

Then(/^"(.*?)" should be able to respond "(.*?)" and log out$/) do |user, message |
  find('TextArea').set(message + " \n")
  sleep(1)
  expect(page).to have_text(message)
  click_link "Sign Out"
end

Then(/^"(.*?)" should see the "(.*?)" in his inbox$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Given(/^that "(.*?)" and "(.*?)" are registered users$/) do |arg1, arg2|
  create(:user, username: arg1 )
  create(:user, username: arg2 )

end
