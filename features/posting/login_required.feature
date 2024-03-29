
Feature: login to dib
  As a looker who wants to dibs or on my way an item, I must sign in before proceeding.

  Background:
  	Given that I am not logged in and can see some there is an item I want to dib

  @javascript	
  Scenario: Get redirected to sign in
  	When I try to dib an item
  	Then I should see a message asking me to sign in
  	And I should see the sign in window
