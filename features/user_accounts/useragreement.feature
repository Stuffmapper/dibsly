Feature: User Agreement
	As a user who uses an app/website service I want to agree with a User Agreement only when I create my account for the first time (i.e. if I want to Dib something or List something).


	Background:
		Given that I am on the home page

	@javascript	
	Scenario: Old Fashion Signup
		Given that I have the signup page open.
		And I signup with a username password email and phone
		Then I should expect to see a user agreement

		
