Given(/^that I am using the same email for my google and facebook$/) do
 	@facebook_email = 'fake@email.com'
 	@google_email = 'fake@email.com'
 	@email = 'fake@email.com'   # express the regexp above with the code you wish you had
end

Given(/^that I have the signup page open\.$/) do 
	# express the regexp above with the code you wish you had
  visit('/')
  click_link('Sign Up')
end

Given(/^I enter username password email and phone$/) do
 
  fill_in 'username', with: 'fakeuser'
  fill_in 'email', with: @email
  fill_in 'password', with: "123456"
  fill_in 'password_confirmation', with: "123456"
  fill_in 'phone_number', with: "8675309"
end

Then(/^I should be able to sign in with my username and password$/) do
  click_link 'Sign In'
  fill_in 'username', with: 'fakeuser'
  fill_in 'password', with: '123456'
  click_button 'Sign In'
  expect(page).to have_text('Successfully Signed In')
end

Then(/^I should be able to go to my account with google and facebook$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that I already have an account$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^press SignUp$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be see the "(.*?)" message$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
