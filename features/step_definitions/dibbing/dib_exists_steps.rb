Then(/^It should not be on the map and Jill should not be able to dib it\.$/) do
  center_map_to_post @shoes
  click_link 'Get Stuff'
  expect(page).to_not have_text 'Details'
  @shoes.reload
  expect(@shoes.status).to eq "gone"
  visit @shoes.permalink
end

Then(/^I should see the shoes in the menu$/)  do
  click_link 'Get Stuff'
  page.find(".stuff-view").click
  sleep(1)
  within('.stuffmapper-menu') do
    expect(page).to have_text("shoes")
  end
end
