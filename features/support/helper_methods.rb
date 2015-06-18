
module FormSubmissionHelpers
  def sign_in user
    allow(ApplicationController).to receive(:current_user){ user }
    first(:link,'Sign In').click
    fill_in 'username', with: user.username
    fill_in 'password', with: '123456'
    within('.modal-footer') do
       click_button 'Sign In'
    end
  end
end

module MapCenterHelpers
  def center_map_to_post post
   	execute_script("var postLatLng = new google.maps.LatLng(#{post.latitude}, #{post.longitude});
    	var map = angular.element('map').scope().map;
    	map.panTo(postLatLng);
      google.maps.event.trigger(map, 'dragend');")
	end
end


World(FormSubmissionHelpers)
World(MapCenterHelpers)
