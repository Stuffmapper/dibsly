
When(/^I log in and give stuff$/) do
  
  visit ('/')
  sign_in @current_user
  visit ('/menu/giveStuff')
  sleep(2)
  page.attach_file('give-stuff-file-1', Rails.root.join("spec/factories/shoes.png"), :visible=>false)
 end


Then(/^I should be able to put  "(.*?)" in the description field$/) do |arg1|
expect(@current_user.posts.count).to eq 0
	within('#give-stuff') do
 		expect(page).to have_field 'description'
    expect(page).to have_field 'title'
 		fill_in 'description', with: arg1
    fill_in 'title', with: arg1
 		click_button 'Map my stuff'
  end
  sleep(6)
  expect(@current_user.posts.count).to eq 1
  expect(@current_user.posts.first.description).to eq arg1
end

Then(/^I should see my post in my stuff with the description "(.*?)"$/) do |arg1|
  click_link "My Stuff"
  sleep(2)
  expect(page).to have_text(arg1)
end
#
#
#
#
#
#
#description field
#
#
#
#
#

Given(/^that Jack is is a registered user and posted shoes with the description "(.*?)"$/) do |arg1|
   jack = create(:user, username: "Jack" )
   VCR.use_cassette('posting3', :match_requests_on => [:method] ) do

     @post = build(:post,
           creator_id: jack.id,
           latitude: "47.6097",
           longitude: '-122.3331',
           description: arg1  )
      @post.save
    end
end

Given(/^I visit the page for shoes$/) do
  visit('/post/' + @post.id.to_s )
end

Then(/^I should see the description$/) do
  expect(page).to have_text(@post.description)
end
#
#
#
#
#
##LOGIN REQUIRED
##

Given(/^that I am not logged in and can see some there is an item I want to dib$/) do
  steps %{
    Given I already have an account and a post

  }

end

When(/^I try to dib an item$/) do
  visit('/post/' + @post.id.to_s )
  page.execute_script "window.scrollBy(0,10000)"
  find(:button, 'I want').click


end

Then(/^I should see a message asking me to sign in$/) do

  expect(page).to have_text('Please sign in')

end

Then(/^I should see the sign in window$/) do

  expect(page).to have_selector('#signin')
end

Given(/^that I am not logged in$/) do
  #do nothing
end

When(/^I try to post an item$/) do
  visit('/')
  click_link('Give Stuff')

end


### VIEW PHOTO
When(/^click on an item's description on the map$/) do
 expect(page.body).to have_selector('#google-map')
      #this is a hack - still not sure how to test google marker photos
 expect(page).to have_xpath("//img[contains(@src,'pin.svg')]", :visible => false)


end

Then(/^I should see a photo$/) do
  expect(page).to have_xpath("//img[contains(@src,'pin.svg')]", :visible => false)
end

When(/^click on an item on in stuff$/) do
  click_link 'Get Stuff'
  page.first('.stuff-view').click
 #express the regexp above with the code you wish you had
end

Then(/^I should see a photo of the stuff$/) do

  expect(page).to have_xpath("//img[contains(@src,'pin.svg')]", :visible => false)

end

## Active management
Given(/^I already have an account and a post$/)  do
    VCR.use_cassette('posting2', :match_requests_on => [:method] ) do
      @current_user = create(:user)
      @post = build(:post,
                creator_id: @current_user.id,
                latitude: "47.6097",
                longitude: '-122.3331'
                )
      @post.save
   end  # express the regexp above with the code you wish you had
end

When(/^I log in and go to my stuff$/) do
  visit('/')
  sign_in @current_user
  click_link('My Stuff')
end

Then(/^I should have an edit option$/) do
  click_button "Settings"
  expect(page).to have_button("Edit")
  
end

Then(/^I should be able to click edit and change the details$/) do
  click_button 'Edit'
  fill_in 'description', with: "I have changed the details"
  page.execute_script "window.scrollBy(0,10000)"
  find(:button,"Update" ).click
  sleep(1)
  expect(page.body).to have_text('Your post has been updated') # express the regexp above with the code you wish you had
  @shoes = @post
  steps %{
    When I visit the shoes permalink page
  }
  expect(page.body).to have_text("I have changed the details") # express the regexp above with the code you wish you had

end

When(/^I edit my stuff$/) do
  steps %{
    When I log in and go to my stuff
    Then I should have an edit option
  }
  click_button 'Edit'
end


Then(/^I should also be able to depublish it$/) do
  expect(page).to have_button("Depublish")
  click_button "Depublish"
end

Then(/^it should not be viewable$/) do
  click_link ('Get Stuff')
   execute_script("var myLatLng = new google.maps.LatLng(#{@post.latitude}, #{@post.longitude});
    var map = angular.element('map').scope().map;
    map.panTo(myLatLng);
    map.setZoom(16);")
  sleep(1)
  within('#get-stuff') do
    expect(page).to_not have_text(@post.description)
  end
end

##POSTING OUT OF MY HANDS

When(/^I login and give stuff and select on the curb$/) do
  visit '/'
  click_link 'Give Stuff'
  sign_in @current_user


end

Then(/^the post should set the post's status to out of my hands$/) do
  click_link "Give Stuff"


 #TODO - Mock out paperclip properly - this is  not a good test
 #This is making a real request to aws everytime- (this is bad)


  page.attach_file('give-stuff-file', Rails.root.join("spec/factories/shoes.png"))
  check "on_the_curb"
  click_button "Give this stuff!"
  sleep(4)

end

Then(/^I should be able to change the out of my hands status after it's posted$/) do
   #TODO - Mock out paperclip properly - this is  not a good test
    VCR.use_cassette('posting1', :match_requests_on => [:method] ) do
      @post = build(:post,
        creator_id: @current_user.id,
        latitude: "47.6097",
        longitude: '-122.3331',
        on_the_curb: true)
      @post.save
   end
   @post.reload
   expect(@post.on_the_curb).to eq true
    visit('/post/' + @post.id.to_s )
    page.execute_script "window.scrollBy(0,10000)"
    first(:button, 'Edit').click
    uncheck 'on_the_curb'
    click_button "Update"
    sleep(1)
    @post.reload
    expect(@post.on_the_curb).to eq false

end


Given(/^I'm a registered user with a verified email$/) do
  @user = create(:user)
end

When(/^I try to give stuff after logging in$/) do
  visit '/'
  sign_in @user
  click_link "Give Stuff"
end

Then(/^I should be able to change my photo before submitting$/) do
  page.attach_file('give-stuff-file-1', Rails.root.join("spec/factories/shoes.png"), :visible=>false)
  page.attach_file('give-stuff-file-2', Rails.root.join("spec/factories/free_smiles.png"), :visible=>false)
  fill_in 'title', with: 'this is a title'
  page.execute_script "window.scrollBy(0,10000)"
  click_button "Map"
  sleep(3)
  expect(Post.count).to eq 1
  expect(Image.count).to eq 1

end
