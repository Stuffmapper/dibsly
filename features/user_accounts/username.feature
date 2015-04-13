Feature: Standard Sign Up	
	As a user who doesn't want their account name to be personally identifiable I will sign up with a pseudonym so I feel safer.


	Background:
		Given that I am not logged in and don't have an account

	@javascript	
	Scenario: Old Fashion Signup
		Given that I have the signup page open.
		Then I should see a field for "username" 
		And I signup with a username password email and phone
		Then I should be able to sign in with my username and password


