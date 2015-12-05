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

  open_email(@user_jack.email)

  expect(current_email.body).to have_text( "dibbed your stuff"   )

end

When(/^Jill has dibbed Jack's shoes$/) do
  @shoes.create_new_dib(@user_jill )
end



When(/^I visit the shoes permalink page$/) do
  center_map_to_post @shoes
  visit('/post/' + @shoes.id.to_s )
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
  find('.get-messages').click


  sleep(5)


  expect(page.body).to have_text('stuffmapper.com says')
end

#priority status

When(/^I respond, the post should not be available thirty minutes from now$/) do
  find('.get-messages').click
  find('.accordion-toggle').click
  sleep 2
  fill_in 'message_response', with: "Hey, when can I get that item?"
  click_button 'send'
  sleep 1
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
