
When(/^I manage dibs for shoes in My Stuff$/) do
  visit '/'
  sign_in @current_user
  click_link('My Stuff')
  expect(page).to have_text 'Want!ed'
end


When(/^I reject current dibber and select "(.*?)"$/) do |arg1|
  page.find('button', :text => "Settings").click
  page.find('button', :text =>  arg1).click
  sleep(1)
end


Then(/^"(.*?)" should be the  current dibber of "(.*?)" and they should display dibbed$/) do |username, item_description|
  post = Post.find_by_description(item_description)
  expect(post.current_dibber.username).to eq username
  within('#my-stuff') do
  	expect(page.body).to have_text "Wanted!"
    expect(page.find('button', :text=> 'Wanted', :visible => true)).to_not eq nil
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

Then(/^Jill should be able to see the item on the map and dib the item\.$/) do
  expect(Dib.count).to eq 1
  @shoes.reload
  expect(@shoes.available_to_dib?).to eq true
  click_link 'Sign Out'
  sign_in @user_jill
  center_map_to_post @shoes
  click_link "Get Stuff"
  expect(page).to have_text 'shoes'
  first(:button, 'Dib').click
  sleep(6)
  expect(Dib.count).to eq 2
  expect(@user_jill.dibs.first.post).to eq @shoes
  @shoes.reload
  expect(@shoes.available_to_dib?).to eq false
  click_link 'Sign Out'

end
