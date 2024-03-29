Feature: Verification email with standard sign up
	As a user that signs up the standard way
	I should receive a welcome email that requests email verification. When I click verify email, my email should be verified and then I can post and dib items

	Background:
		Given that I am not logged in and don't have an account
		And that Jack is is a registered user and posted shoes with the description "awesome kicks"

	@javascript	
	Scenario: Follows email verification link
		Given that I have the signup page open
		And I signup with a username password email and phone
		Then I should receive a welcome email
		When I follow the link in the welcome email 
		Then I should be able to post an item and dib Jacks shoes

	@javascript		
	Scenario: Doesn't follow email verification link
		Given that I have the signup page open
		And I signup with a username password email and phone
		When I sign in I should not be able to dib Jack's shoes or post an item.
