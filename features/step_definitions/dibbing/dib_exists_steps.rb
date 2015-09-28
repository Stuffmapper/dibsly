
Then(/^I should see the shoes in the menu$/)  do
  click_link 'Get Stuff'
  page.find(".stuff-view").click
  sleep(1)
  within('.stuffmapper-menu') do
    expect(page).to have_text("shoes")
  end
end
