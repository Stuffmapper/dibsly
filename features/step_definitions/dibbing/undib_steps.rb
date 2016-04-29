When(/^I go to my stuff and undibs Jack's shoes$/) do
  sleep(1)
  click_link('My Stuff')
  sleep(1)
  expect(page.body).to have_text 'shoes'
  find('.item-details-link').click
  sleep(2)
  click_link "unDibs!"
end

When(/^I visit the map location where the shoes are\.$/) do
   center_map_to_post Post.find_by_description "shoes"
    sleep(1)
end
