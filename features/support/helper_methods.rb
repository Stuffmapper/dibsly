
module FormSubmissionHelpers
  def sign_in user
    if first(:link, 'Sign Out') != nil
      first(:link, 'Sign Out').click
    end
    execute_script("window.localStorage.removeItem('markers'); console.log('hello');")
    visit('/')
    allow(ApplicationController).to receive(:current_user){ user }
    first(:link,'Sign In').click
    fill_in 'username', with: user.username
    fill_in 'password', with: '123456'
    within('#signin') do
       click_button 'Sign In'
    end
  end
end

module MapCenterHelpers
  def center_map_to_post post
    visit('/')
    string = {lat: post.latitude, lng: post.longitude }.to_json
   	execute_script("window.localStorage.setItem('mapcenter', '#{string}'); console.log('hello');")
    visit('/')
	end
end


World(FormSubmissionHelpers)
World(MapCenterHelpers)
