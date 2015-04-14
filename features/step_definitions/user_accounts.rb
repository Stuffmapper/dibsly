Given(/^that I am using the same email for my google and facebook$/) do
 	@facebook_email = 'fake@email.com'
 	@google_email = 'fake@email.com'
 	@email = 'fake@email.com'   # express the regexp above with the code you wish you had
end

Given(/^that I am not logged in and don't have an account$/) do
  
end

Then(/^I should see a field for "(.*?)"$/) do |arg1|
  expect(page).to have_field(arg1)
end



Given(/^that I have the signup page open\.$/) do 
	# express the regexp above with the code you wish you had
  visit('/')
  click_link('Sign Up')
end


Given(/^I signup with a username password email and phone$/) do
 
  fill_in 'username', with: 'fakeuser'
  fill_in 'first_name', with: 'Ben'
  fill_in 'last_name', with: 'Dere'
  fill_in 'email', with: 'fake@email.com'
  fill_in 'password', with: "123456"
  fill_in 'password_confirmation', with: "123456"
  fill_in 'phone_number', with: "8675309"
  within('.modal-footer') do 
    click_button "Sign Up"
  end  
  sleep(1)
end

Then(/^I should be able to sign in with my username and password$/) do
  expect(page).to_not have_text('Sign Out')
  
  sign_in User.find_by_username('fakeuser')

  expect(page.body).to have_text('You have been signed in')
  expect(page).to have_text('Sign Out')
end

Then(/^I should be able to go to my account with google and facebook$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that I already have an account$/) do
  
  User.create :last_name  => 'Name',
              :first_name => 'fake', 
              :username   => 'fakeuser',
              :password   => '123456',
              :email      => 'fake@email.com',
              :status     => 'new',
              :ip         => '' 
end


Then(/^I should be see the "(.*?)" message$/) do |arg1|
  expect(page.body).to have_text(arg1)
end

Given(/^that I have an account and my username is Jack$/) do
  create(:user, :username => 'Jack')
end

Given(/^that I have the signin page open\.$/) do
  visit('/')
  click_link('Sign In')
end

Given(/^I fail to sign in with the password "(.*?)"$/) do |arg1|
  fill_in 'username', with: 'Jack'
  fill_in 'password', with: arg1
  within('.modal-footer') do 
    click_button 'Sign In'
  end
  sleep(1)
  expect(page.body).to have_text("Wrong username or password")  
end

Then(/^I should see a forgot password\? link$/) do

  expect(page).to have_selector(:link_or_button, 'Forgot Password?')
end

When(/^I follow the forgot password link and enter my email$/) do
  click_button('Forgot Password?') 
  fill_in 'email', with: 'fake@email.com'
  click_button('Reset') 
end

Then(/^I should receive an email with a link to reset my password$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I follow the reset password link and set my new password to "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be able to login with my username and IamB@tman(\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

