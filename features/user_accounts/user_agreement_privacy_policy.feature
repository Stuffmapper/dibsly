Feature: User Agreement
	As a user who uses an app/website service I want to agree with a User Agreement only when I create my account for the first time (i.e. if I want to Dib something or List something). I also want to see a privacy policy


	Background:
		Given that I am on the home page

	@javascript
	Scenario: Old Fashion Signup
		Given that I have the signup page open
		Then I should expect to see a "Terms of Use"
		And I should expect to see a "Privacy Policy"
