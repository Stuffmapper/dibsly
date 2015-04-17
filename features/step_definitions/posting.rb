
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
  within('#my-stuff-container') do 
   expect(page).to have_text(arg1)
  end
end
