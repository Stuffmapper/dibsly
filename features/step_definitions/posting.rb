
When(/^I log in and give stuff$/) do
  visit ('/')

  sign_in @current_user 
  click_link('Give Stuff')
  execute_script("$(document.elementFromPoint(100, 100)).click()")
  #clicks on random page to place marker - needs refactoring for better accuracy
end


Then(/^I should be able to put  "(.*?)" in the description field$/) do |arg1|
	pending

 	VCR.use_cassette('aws_cucumber', :match_requests_on => [:method] ) do 
 	end # express the regexp above with the code you wish you had
end

Then(/^I should see my post in my stuff with the description "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
