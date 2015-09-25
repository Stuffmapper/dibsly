
When(/^I reject current dibber and select "(.*?)"$/) do |arg1|
  pending
end


Then(/^"(.*?)" should be the  current dibber of "(.*?)" and they should display dibbed$/) do |username, item_description|
  post = Post.find_by_description(item_description)
  expect(post.current_dibber.username).to eq username
  within('#my-stuff') do
  	expect(page.body).to have_text "Wanted!"
  end
end

Then(/^"(.*?)" should not be the current dibber of "(.*?)" and they should not display dibbed$/) do |username, item_description|
  expect(post.current_dibber.username).to_not eq username
  within('#my-stuff') do
  	expect(page.body).to_not have_text "Wanted!"
  end
end
