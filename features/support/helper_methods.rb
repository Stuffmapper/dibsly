
module FormSubmissionHelpers
  def sign_in user
    if first(:link, 'Sign Out') != nil
      first(:link, 'Sign Out').click
    end
    execute_script("window.localStorage.removeItem('markers');")
    visit('/')
    allow(ApplicationController).to receive(:current_user){ user }
    sleep(1)
    if first(:link, 'Sign Out') != nil
      first(:link, 'Sign Out').click
    end
    sleep(1)
    first(:link,'Sign In').click
    fill_in 'username', with: user.username
    fill_in 'password', with: '123456'
    sleep(2)
    within('#signin') do
       click_button 'Sign In'
    end
    sleep(2)
  end
  def make_file_input_interactable
    page.execute_script("$('#give-stuff-file-1').show();$('#give-stuff-file-2').show();")
  end
end

module MapCenterHelpers
  def center_map_to_post post
    visit('/')
    string = {lat: post.latitude, lng: post.longitude }.to_json
   	execute_script("window.localStorage.setItem('mapcenter', '#{string}'); ")
    visit('/')
	end
end


World(FormSubmissionHelpers)
World(MapCenterHelpers)
