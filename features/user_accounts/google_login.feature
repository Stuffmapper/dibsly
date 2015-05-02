Feature: Sign Up with google	
	As a new user, I want to be able to sign up with my google account

	Background:
		Given that I am not logged in and don't have an account

	@javascript	
	Scenario: Login with email
		When I visit the signup page and click Google login
		Then I should have an account created and my email should be marked verified.
		