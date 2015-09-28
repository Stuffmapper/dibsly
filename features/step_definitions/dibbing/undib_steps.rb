When(/^I go to my stuff and undibs Jack's shoes$/) do
  click_link('My Stuff')
  sleep(1)
  expect(page.body).to have_text 'shoes'
  click_link "Item details"
  sleep(2)
  click_link "Undib!"
end

When(/^I visit the map location where the shoes are\.$/) do
   center_map_to_post Post.find_by_description "shoes"
    sleep(1)
end