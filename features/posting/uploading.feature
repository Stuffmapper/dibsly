Feature: Update a dib
	As a lister, I want have a better experience uploading a photo

Background:
	Given I'm a registered user with a verified email

@javascript
Scenario:  Upload Photo
  When I try to give stuff after logging in
  Then I should be able to change my photo before submitting
