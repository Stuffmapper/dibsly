Feature: Standard Sign Up	
	As a user who forgot what my password was I want to click a "Reset Password" button and be able to enter my email so I can be sent an email with a link to reset my password.

	Background:
		Given that I have an account and my username is Jack

	@javascript	
	Scenario: I reset my password
		Given that I have the signin page open.
		And I fail to sign in with the password "IamB@tman1"
		Then I should see a forgot password? link 
		When I follow the forgot password link and enter my email
		Then I should receive an email with a link to reset my password
		When I follow the reset password link and set my new password to "IamB@tman1"
		Then I should be able to login with my username and IamB@tman1
