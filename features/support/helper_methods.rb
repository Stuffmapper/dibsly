
module FormSubmissionHelpers
  def sign_in user
    if first(:link, 'Sign Out') != nil
      first(:link, 'Sign Out').click
    end
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
   	execute_script("localStorage.setItem('mapcenter', '{lat: #{post.latitude}, lng: #{post.longitude} }')")
    visit('/')
	end
end


World(FormSubmissionHelpers)
World(MapCenterHelpers)
