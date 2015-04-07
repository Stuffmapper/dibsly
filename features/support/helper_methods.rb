
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
World(FormSubmissionHelpers)