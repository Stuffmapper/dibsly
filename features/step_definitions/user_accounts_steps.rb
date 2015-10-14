Given(/^that I am on the home page$/) do
  visit('/')
end



Given(/^that I am using the same email for my google and facebook$/) do
 	@facebook_email = 'fake@email.com'
 	@google_email = 'fake@email.com'
 	@email = 'fake@email.com'
  #see test.rb in environment to make sure
  #that omniauth google and fb emails are configured to match
end


Given(/^that I am not logged in and don't have an account$/) do
  #do nothing
end


Then(/^I should see a field for "(.*?)"$/) do |arg1|
  expect(page).to have_field(arg1)
end



Given(/^that I have the signup page open$/) do

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
  within('.sign-up') do
    click_button "Sign Up"
  end
  sleep(2)
  if first(:link, 'Sign Out') != nil
    first(:link, 'Sign Out').click
  end

end

Then(/^I should be able to sign in with my username and password$/) do
  user = User.find_by_username('fakeuser')
  sign_in user
  expect(page).to have_text('Sign Out')

end

Then(/^I should be able to go to my account with google and facebook$/) do
   if first(:link, 'Sign Out') != nil
    first(:link, 'Sign Out').click
   end
   expect(User.count).to eq 1
   first(:link, 'Sign In').click
   click_link('Facebook')
   expect(User.count).to eq 1
   expect(page).to have_text 'Sign Out'

   click_link 'Sign Out'
   expect(page).to_not have_text 'Sign Out'
   first(:link, 'Sign In').click
   click_link 'Google'
   expect(User.count).to eq 1
   expect(page).to have_text 'Sign Out'

end

Given(/^that I already have an account$/) do


  @current_user = create(:user, :last_name  => 'Name',
              :first_name => 'fake',
              :username   => 'fakeuser',
              :password   => '123456',
              :email      => 'fake@email.com',
              :status     => 'new',
              :ip         => '' )


end

Then(/^I should expect to see a "(.*?)"$/) do |policy|
  within('.sign-up') do 
    click_link(policy)
    expect(page.body).to have_text(policy)
  end
end


Then(/^I should be see the "(.*?)" message$/) do |arg1|
  expect(page.body).to have_text(arg1)
end

Given(/^that I have an account and my username is Jack$/) do
  @user = create(:user, :username => 'Jack')
end

Given(/^that I have the signin page open\.$/) do
  visit('/')
  sleep(2)
  if first(:link, 'Sign Out') != nil
    first(:link, 'Sign Out').click
  end
  first(:link, 'Sign In').click
end

Given(/^I fail to sign in with the password "(.*?)"$/) do |arg1|
  fill_in 'username', with: 'Jack'
  fill_in 'password', with: arg1
  within('.signin') do
    click_button 'Sign In'
  end
  sleep(1)
  expect(page.body).to have_text("Wrong username or password")
end

Then(/^I should see a forgot password\? link$/) do

  expect(page).to have_selector(:link_or_button, 'Forgot Password?')
end

When(/^I follow the forgot password link and enter my email$/) do
  click_link('Forgot Password?')
  fill_in 'email', with: @user.email


  click_button "Reset"
  sleep(2)

end

Then(/^I should receive an email with a link to reset my password$/) do
  open_email(@user.email)
  expect(ActionMailer::Base.deliveries.empty?).to be(false)
  expect(current_email.body).to have_text(   'user/reset/' + User.find_by_email(@user.email).password_reset_token )

end

When(/^I follow the reset password link and set my new password to "(.*?)"$/) do |arg1|
  current_email.click_link "http://"
  expect(page).to have_content("Change Your Password")
  fill_in 'password', with: arg1
  fill_in 'password_confirmation', with: arg1
  click_button 'Change Password'
end


Then(/^I should be able to login with my username and "(.*?)"$/) do |arg1|
    sleep(2)
    if first(:link, 'Sign Out') != nil
      first(:link, 'Sign Out').click
    end

    sleep(2)
    first(:link, 'Sign In').click
    fill_in 'username', with: @user.username
    fill_in 'password', with: arg1
    within('.signin') do
       click_button 'Sign In'
    end
    expect(page).to have_text("You have been signed in")
end

Then(/^I should be able to see "(.*?)"$/) do |arg1|
  expect(page).to have_text(arg1)
end



When(/^I try to login, I should be able to use my email in place of username$/) do
    visit('/')
    first(:link,'Sign In').click
    fill_in 'username', with: @current_user.email
    fill_in 'password', with: @current_user.password
    within('.signin') do
       click_button 'Sign In'
    end
    sleep(1)
    expect(page).to have_text("You have been signed in")

end

##EMAIL VERIFICATION

Then(/^I should receive a welcome email$/) do
  sleep(1)
  @current_user = User.last
  open_email(@current_user.email)
  expect(current_email.body).to have_text("Welcome to Stuffmapper!" )

end

When(/^I follow the link in the welcome email$/) do
  expect(@current_user.verified_email).to eq false
  current_email.click_link "http://"
  sleep(2)
  @current_user.reload
  expect(@current_user.verified_email).to eq true
end

Then(/^I should be able to post an item and dib Jacks shoes$/) do
  visit '/'
  if first(:link, 'Sign Out') != nil
    first(:link, 'Sign Out').click
  end

  steps %{
    When I log in and give stuff
    Then I should be able to put  "These are some awesome kicks" in the description field

  }
  @shoes = Post.first
  execute_script("var myLatLng = new google.maps.LatLng(#{@shoes.latitude}, #{@shoes.longitude});
    var map = angular.element('map').scope().map;
    map.panTo(myLatLng);
    map.setZoom(24);")

  click_link 'Get Stuff'

  page.all(:button, "Dib")[0].click
  sleep(1)
  expect(page).to have_text('Dibbed your stuff')

 end



When(/^I sign in I should not be able to dib Jack's shoes or post an item\.$/) do
  visit '/'

  if first(:link, 'Sign Out') != nil
    first(:link, 'Sign Out').click
  end

  @current_user = User.last
  steps %{
    When I log in and give stuff
  }
  allow( Post ).to receive( :has_attached_file ).and_return false
  VCR.use_cassette('aws_cucumber', :match_requests_on => [:method] ) do
      @post = build(:post, creator_id: @current_user.id, latitude: "47.6097", longitude: '-122.3331', description: "okkk" )
   end
   allow(Post).to receive( :new ).and_return( @post )
   allow(Post).to receive( :save ).and_call_original

    within('#give-stuff') do
      expect(page).to have_field 'description'
      fill_in 'description', with: "okkk"
      click_button 'Give this stuff!'
    end
  sleep(2)
  expect(page).to have_text('Please verify your email to give stuff')
  click_link('Sign Out')
  @shoes = Post.first
  steps %{
    When I log in and visit the map location where the shoes are.
    When I hit dib
  }
  sleep(2)
  expect(page).to have_text('Please verify your email to dib')

end
#"/user/signup"

#GOOGLE LOGIN

When(/^I visit the signup page and click Google login$/) do
  expect( User.count).to eq 0
  visit "/user/signup"
  click_link "Google"

end

Then(/^I should have an account created and my email should be marked verified\.$/) do
   expect(User.count).to eq 1
   expect(User.last.verified_email).to eq true
 end
