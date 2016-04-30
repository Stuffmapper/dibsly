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
    sleep(2)
    fill_in 'username', with: 'fakeuser'
    sleep(2)
    fill_in 'first_name', with: 'Ben'
    sleep(2)
    fill_in 'last_name', with: 'Dere'
    sleep(2)
    fill_in 'email', with: 'fake@email.com'
    sleep(2)
    fill_in 'password', with: "123456"
    sleep(2)
    fill_in 'password_confirmation', with: "123456"
    sleep(2)
    fill_in 'phone_number', with: "8675309"
    sleep(2)
    within('.sign-up') do
        sleep(2)
        click_button "Sign Up"
    end
    if first(:link, 'Sign Out') != nil
        first(:link, 'Sign Out').click
    end
end

Then(/^I should be able to sign in with my username and password$/) do
    sleep(1)
    user = User.find_by_username('fakeuser')
    sign_in user
    expect(page).to have_text('Sign Out')

end

Then(/^I should be able to go to my account with google and facebook$/) do
    if first(:link, 'Sign Out') != nil
        first(:link, 'Sign Out').click
    end
    expect(User.count).to eq 1
    sleep(5)
    first(:link, 'Sign In').click
    within '#signin' do
        page.find('#Facebook').click
    end
    expect(User.count).to eq 1
    expect(page).to have_text 'Sign Out'

    click_link 'Sign Out'
    expect(page).to_not have_text 'Sign Out'
    sleep(5)
    first(:link, 'Sign In').click
    within('#signin') do
        page.find('#Google').click
        expect(User.count).to eq 1
    end
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
    click_button "Close"
end


Then(/^I should be see the "(.*?)" message$/) do |arg1|
    sleep(1)
    expect(page.body).to have_text(arg1)
    sleep(5)
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
    sleep(2)
    fill_in 'username', with: 'Jack'
    sleep(2)
    fill_in 'password', with: arg1
    sleep(2)
    within('.signin') do
        sleep(2)
        click_button 'Sign In'
    end
    sleep(2)
    expect(page.body).to have_text("Wrong username or password")
end

Then(/^I should see a forgot password\? link$/) do
    sleep(2)
    expect(page).to have_selector(:link_or_button, 'Forgot Password?')
end

When(/^I follow the forgot password link and enter my email$/) do
    click_link('Forgot Password?')
    fill_in 'email', with: @user.email


    click_button "Reset"
    sleep(2)

end

Then(/^I should receive an email with a link to reset my password$/) do
    sleep(2)
    @email = MandrillMailer::deliveries.detect{
        |mail| mail.template_name == 'password-reset' &&
        mail.message['to'].any? { |to| to[:email] == @user.email }}
    sleep(10)
    expect(@email).to_not be(nil)
    sleep(2)
    @link = @email.message["global_merge_vars"].select { |var| var['name'] == "CHANGEPASSWORD" }[0]["content"]
    sleep(2)
    expect(@link).to have_text(   'user/email/reset/' + User.find_by_email(@user.email).password_reset_token )
    sleep(2)

end

When(/^I follow the reset password link and set my new password to "(.*?)"$/) do |arg1|
    visit('#/menu/user/email/reset/' + User.find_by_email(@user.email).password_reset_token )

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
    @email = MandrillMailer::deliveries.detect{ |mail| mail.template_name == 'email-verification' && mail.message['to'].any? { |to| to[:email] == @current_user.email }}
    expect(@email).to_not be_nil
    # email.message["global_merge_vars"]

    #expect(current_email.body).to have_text("Welcome to Stuffmapper!" )

end

When(/^I follow the link in the welcome email$/) do
    expect(@current_user.verified_email).to eq false
    link = @email.message["global_merge_vars"].select { |var| var['name'] == "CONFIRMEMAIL" }[0]["content"]
    expect(link).to have_text( '#/users/email/' + User.find_by_email(@current_user.email).verify_email_token )
    visit link
    sleep(2)
    @current_user.reload
    expect(@current_user.verified_email).to eq true
end

Then(/^I should be able to post an item and dib Jacks shoes$/) do
    visit '/'
    if first(:link, 'Sign Out') != nil
        first(:link, 'Sign Out').click
    end
    sign_in @current_user
    center_map_to_post Post.last
    visit('#/menu/giveStuff')
    sleep(2)
    make_file_input_interactable
    page.attach_file('give-stuff-file-1', Rails.root.join("spec/factories/shoes.png"), :visible=>false)
    steps %{
        Then I should be able to put  "These are some awesome kicks" in the description field

    }
    @shoes = Post.first
    center_map_to_post @shoes

    click_link 'Get Stuff'
    page.all(".stuff-view")[1].click
    page.execute_script "window.scrollBy(0,10000)"
    page.first(:button, "Dib").click
    sleep(2)
    expect(page).to have_text('Dibbed')

end



When(/^I sign in I should not be able to dib Jack's shoes or post an item\.$/) do
    @current_user = User.last
    sign_in @current_user
    allow( Post ).to receive( :has_attached_file ).and_return false
    VCR.use_cassette('aws_cucumber', :match_requests_on => [:method] ) do
        @post = build(:post, creator_id: @current_user.id, latitude: "47.6097", longitude: '-122.3331', description: "okkk" )
    end
    allow(Post).to receive( :new ).and_return( @post )
    allow(Post).to receive( :save ).and_call_original
    center_map_to_post @post
    visit ('#/menu/giveStuff')
    sleep(2)

    make_file_input_interactable
    page.attach_file('give-stuff-file-1', Rails.root.join("spec/factories/shoes.png"), :visible=>false)
    within('#give-stuff') do
        expect(page).to have_field 'description'
        fill_in 'description', with: "okkk"
        fill_in 'title', with: "okkk"
        click_button 'Map'
    end
    sleep(2)
    expect(page).to have_text('Please verify your email to give stuff')
    click_link('Sign Out')
    @shoes = Post.first
    steps %{
        When I log in and visit the map location where the shoes are.
    }
    click_link 'Get Stuff'
    page.find('.stuff-view').click
    sleep(2)
    within('.post-view') do
        page.execute_script "window.scrollBy(0,10000)"
        page.find(:button, "Dib").click
    end
    @shoes.reload
    expect(@shoes.available_to_dib?).to eq true
    expect(page).to have_text('Please verify your email to dib')

end
#"/user/signup"

#GOOGLE LOGIN

When(/^I visit the signup page and click Google login$/) do
    expect( User.count).to eq 0
    visit ""
    click_link 'Sign In'
    within '#signin' do
        page.find('#Google').click
    end
end

Then(/^I should have an account created and my email should be marked verified\.$/) do
    expect(User.count).to eq 1
    expect(User.last.verified_email).to eq true
end
