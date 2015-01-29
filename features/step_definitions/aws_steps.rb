

Given(/^that I already have an account$/) do
   user = User.create(:name => "John", 
   					  :password => '123456',
   					  :password_confirmation => '123456',
   					  :email => 'fake@email.com',
   					  :status => 'new',
   					  :ip => '1')
   user.save!
end

Given(/^I am logged in\.$/) do

  visit('/')
  click_link('Login')
  within('#log-in-form') do 
    fill_in "Name", :with =>  "John"
    fill_in "Password", :with => '123456'
    click_button "Log in" 
  end
end

Given(/^that I post a picture of shoes$/) do
  visit ('/')
  click_link("give-stuff")
  
  file_path = Rails.root + "spec/fixtures/shoes.png"
  attach_file('post_image', file_path)
  click_button "Give this stuff"
  expect(page).to_not have_content("can't be blank")
end




