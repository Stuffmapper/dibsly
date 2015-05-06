
module FormSubmissionHelpers
  def sign_in user
    click_link 'Sign In'
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
    	map.panTo(postLatLng);")
	end
end


World(FormSubmissionHelpers)
World(MapCenterHelpers)

