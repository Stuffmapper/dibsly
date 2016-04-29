Given(/^I'm a registered user and Jack has posted some shoes and Jill is another registered user$/) do
  VCR.use_cassette('dibbing2', :match_requests_on => [:method] ) do
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @user_jill = create(:user, :username => "Jill")
    @shoes = build(:post, creator_id: @user_jack.id, latitude: "47", longitude: '-122', description: 'shoes', title: 'shoes'  )
    @shoes.save!
  end
end


When(/^I log in and visit the map location where the shoes are\.$/) do
  visit('/')
  sign_in(@current_user)
  sleep(1)
  center_map_to_post @shoes
  sleep(1)

end


When(/^I hit dib$/) do
  click_link 'Get Stuff'
  page.find('.stuff-view').click
  sleep(2)
  within('.post-view') do
    page.execute_script "window.scrollBy(0,10000)"
    page.find(:button, "Dib").click
    sleep(5)
  end
  @shoes.reload
  expect(@shoes.available_to_dib?).to eq false
 end

Then(/^I should not see the shoes in the menu when I visit the map\.$/) do
  visit('/')
  sign_in @user_jill
  center_map_to_post @shoes
  sleep(1)
  within('.stuffmapper-menu') do
    expect(page).to_not have_text("shoes")
  end

end

Then(/^Jack should have been notified of my dib\.$/) do

  @email = MandrillMailer::deliveries.detect{
    |mail| mail.template_name == 'lister-notification' &&
     mail.message['to'].any? { |to| to[:email] == @user_jack.email }}
  expect(@email).to_not be(nil)

end

When(/^Jill has dibbed Jack's shoes$/) do
  @shoes.create_new_dib(@user_jill )
end



When(/^I visit the shoes permalink page$/) do
  center_map_to_post @shoes
  visit( @shoes.permalink )
end

Then(/^I should not be able to dib the item\.$/) do
  sleep(3)
  expect(page).to_not have_text 'I want'# express the regexp above with the code you wish you had
end

Given(/^I'm logged out$/) do
   # express the regexp above with the code you wish you had
end


##UNDIB

Given(/^I'm a registered user and I've dibbed Jack's shoes$/) do
  VCR.use_cassette('dibbing1', :match_requests_on => [:method] ) do
    @current_user = create(:user)
    @user_jack = create(:user, :username => "Jack")
    @shoes = build(:post, creator_id: @user_jack.id, latitude: "47", longitude: '-122', description: 'shoes', title:'shoes' )
    @shoes.save!
    @shoes.create_new_dib(@current_user )
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
 page.find('.stuff-view').click
 expect(page).to have_text("shoes")

end



Then(/^Jack should have been notified of my unDib\.$/) do

  @email = MandrillMailer::deliveries.detect{
    |mail| mail.template_name == 'notify-undib' &&
     mail.message['to'].any? { |to| to[:email] == @user_jack.email }}
  expect(@email).to_not be(nil)

end

### EMAIL CONFIRMATION

Given(/^I've received an email\.$/) do
  @email = MandrillMailer::deliveries.detect{
    |mail| mail.template_name == 'dibber-notification' &&
     mail.message['to'].any? { |to| to[:email] == @current_user.email }}
  expect(@email).to_not be(nil)
end

Then(/^is should explain information about dibs$/) do
  #this info is in the mandrill template
end

Then(/^if I follow the link in the email$/) do
  visit('/')
  sign_in(@current_user)
  @link = @email.message["global_merge_vars"].select { |var| var['name'] == "CHATLINK" }[0]["content"]
  visit @link
end

Then(/^I should be in the in\-app chat$/) do
  sleep(5)
  find("#TextArea").set("Hey I want those \n")

  expect(page.body).to have_text("Hey I want those")
  sleep(2)
  @shoes.reload

  expect(@shoes.status ).to eq 'dibbed'

end

#priority status

When(/^I respond, the post should not be available thirty minutes from now$/) do
  sleep(5)
  find("#TextArea").set("Hey I want those \n")

  expect(page.body).to have_text("Hey I want those")
  sleep(2)
  @shoes.reload
  Timecop.travel(1805)
  @shoes.reload
  expect(@shoes.available_to_dib?).to eq false
  Timecop.return

end

When(/^I don't respond, the post should be available thirty minutes from now$/) do
  visit('/')
  Timecop.travel(1805)
  @shoes.reload
  expect(@shoes.available_to_dib?).to eq true
  Timecop.return
end
