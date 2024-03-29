
When(/^I manage dibs for shoes in My Stuff$/) do
  visit '/'
  sign_in @current_user
  visit '/#menu/mystuff'
  sleep(2)
  expect(page).to have_text 'Active Dibs'
end


When(/^I reject current dibber and select "(.*?)"$/) do |arg1|
  sleep(1)
  page.find('button', :text => "Settings").click
  sleep(1)
  page.find('button', :text =>  arg1).click
  sleep(1)
end


Then(/^"(.*?)" should be the  current dibber of "(.*?)" and they should display dibbed$/) do |username, item_description|
  post = Post.find_by_description(item_description)
  expect(post.current_dibber.username).to eq username
  sleep(2)
  sign_in post.creator
  sleep(2)
  click_link('My Stuff')
  sleep(1)
  within('#my-stuff') do
  	expect(page.body).to have_text "Active Dibs"
    sleep(2)
    expect(page.find('button', :text=> 'Dibbed', :visible => true)).to_not eq nil
  end
end

Then(/^"(.*?)" should not be the current dibber of "(.*?)" and they should not display dibbed$/) do |username, item_description|
  post = Post.find_by_description(item_description)
  expect(post.current_dibber).to_not eq username

  within('#my-stuff') do
  	sleep(5)
    begin
      exists = page.find('button', :text=> 'Wanted', :visible => true)
    rescue Capybara::ElementNotFound
      exists = nil
    end
  	expect(exists).to eq nil
  end
end


When(/^I click "(.*?)" in the settings$/) do |arg1|
  page.find('button', :text => "Settings").click
  page.find('button', :text =>  arg1).click
end



When(/^the details of "(.*?)" should still be viewable$/)  do |description|

  post = Post.find_by_description(description)
  visit(post.permalink)
  sleep(3)
  expect(page.body).to have_text(post.description)
  expect(page.body).to have_text(post.status)
end

When(/^the status of "(.*?)" should have changed to "(.*?)"$/) do |description, status|
  post = Post.find_by_description(description)
  expect(post.status).to eq(status)
end

Then(/^Jill should be able to see the item on the map and dib the item\.$/) do
  jill = User.find_by_username "Jill"
  sign_in jill
  center_map_to_post @shoes
  visit @shoes.permalink
  page.execute_script "window.scrollBy(0,10000)"
  find(:button, 'Dib').click
  sleep(3)
  @shoes.reload
  expect(@shoes.current_dibber).to eq jill

end
