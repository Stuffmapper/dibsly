
When(/^I log in and give stuff$/) do
  visit ('/')

  sign_in @current_user 
  click_link('Give Stuff')
  execute_script("$(document.elementFromPoint(100, 100)).click()")
  page.attach_file('give-stuff-file', Rails.root.join("spec/factories/shoes.png"))
 end


Then(/^I should be able to put  "(.*?)" in the description field$/) do |arg1|
	expect(@current_user.posts.count).to eq 0
  #because this is an upload -  needs a better solution
  #this may be a mock train wreck I need to get paperclip mocking 
  #to work and to remove the VCR calls
   VCR.use_cassette('aws_cucumber', :match_requests_on => [:method] ) do 
      @post = build(:post, creator_id: @current_user.id, latitude: "47.6097", longitude: '-122.3331', description: arg1 ) 
      @post.save!
   end
   allow(Post).to receive( :new ).and_return( @post )
   allow(Post).to receive( :save ).and_return( true )

		within('#give-stuff-form') do 
	 		expect(page).to have_field 'description'
	 		fill_in 'description', with: arg1
	 		click_button 'Submit'
	  end  
    sleep(6)
    expect(@current_user.posts.last).to eq @post
    expect(@current_user.posts.count).to eq 1
end

Then(/^I should see my post in my stuff with the description "(.*?)"$/) do |arg1|
  click_link "My Stuff" 
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
   VCR.use_cassette('aws_cucumber3', :match_requests_on => [:method] ) do 

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
  within('#show-post') do
    expect(page).to have_text(@post.description)
  end # express the regexp above with the code you wish you had
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
  within('#show-post') do 
    click_button('Dib')
  end
end

Then(/^I should see a message asking me to sign in$/) do
  expect(page).to have_text('Please sign in to continue') 
end

Then(/^I should see the sign in window$/) do
  expect(page).to have_selector('#sign-in-form')  
end
Given(/^that I am not logged in$/) do
  #do nothing 
end

When(/^I try to post an item$/) do
  visit('/')
  click_link('Give Stuff')
  click_button('Submit')
end


### VIEW PHOTO
When(/^click on an item's description on the map$/) do
 expect(page.body).to have_selector('#google-map-container')
   within(first('.g-marker', :visible => false)) do
     expect(page).to have_xpath("//img[contains(@src,'shoes.png')]")
  end 


end

Then(/^I should see a photo$/) do
  expect(page).to have_xpath("//img[contains(@src,'shoes.png')]")
end

When(/^click on an item on in stuff$/) do
  
  first(:link, 'Details').click 
 #express the regexp above with the code you wish you had
end

Then(/^I should see a photo of the stuff$/) do
 
  expect(page).to have_xpath("//img[contains(@src,'shoes.png')]")
  
end

## Active management
Given(/^I already have an account and a post$/)  do
    VCR.use_cassette('aws_cucumber3', :match_requests_on => [:method] ) do 
      @current_user = create(:user)
      @post = build(:post, 
                creator_id: @current_user.id, 
                latitude: "47.6097", 
                longitude: '-122.3331') 
      @post.save 
   end  # express the regexp above with the code you wish you had
end

When(/^I log in and go to my stuff$/) do
  visit('/')
  sign_in @current_user
  click_link('My Stuff') 
end

Then(/^I should have an edit option$/) do
  within('#my-stuff') do 
    expect(page).to_not have_button("edit") 
  end   # express the regexp above with the code you wish you had
end

Then(/^I should be able to click edit and change the details$/) do
  click_button 'Edit'
  fill_in 'description', with: "I have changed the details"
  click_button "Update"
  sleep(1)
  expect(page.body).to have_text('Your post has been updated') # express the regexp above with the code you wish you had
  @shoes = @post 
  steps %{
    When I visit the shoes permalink page
  }
  expect(page.body).to have_text("I have changed the details") # express the regexp above with the code you wish you had

end

When(/^I edit my stuff$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should also be able to delete it$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should also be able to depublish it$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^it should not be viewable$/) do
  pending # express the regexp above with the code you wish you had
end





