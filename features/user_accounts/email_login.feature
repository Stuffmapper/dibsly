Feature: Standard Sign Up	
	As a user that cannot remember his or her username
	I want to be able to login with my email 

	Background:
		Given that I already have an account

	@javascript	
	Scenario: Login with email
		When I try to login, I should be able to use my email in place of username
		