
Then(/^I should see the shoes in the menu$/)  do
  click_link 'Get Stuff'
  sleep(5)
  page.find(".stuff-view").click
  sleep(1)
  within('.stuffmapper-menu') do
    expect(page).to have_text("shoes")
  end
end


Then(/^I should not be able to dib the "(.*?)"$/) do |description|
  page.execute_script "window.scrollBy(0,10000)"
  find(:button, 'I want this').click
  post = Post.find_by_description(description)
  expect(post.available_to_dib?).to eq true 
end

