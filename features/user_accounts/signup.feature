Feature: Standard Sign Up	
	As a user, I want to be able to have different options for signing up.


	Background:
		Given that I am using the same email for my google and facebook

	@javascript	
	Scenario: Old Fashion Signup
		Given that I have the signup page open.
		And I signup with a username password email and phone
		Then I should be able to sign in with my username and password
		And I should be able to go to my account with google and facebook
		
	@javascript	
	Scenario: Old Fashion already have an account
		Given that I already have an account
		And I signup with a username password email and phone
		Then I should be see the "Account already created" message
