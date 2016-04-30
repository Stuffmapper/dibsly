
Feature: Login to post
  As a lister who wants to post something, I must sign in before proceeding.

  Background:
  	Given that I am not logged in

  @javascript	
  Scenario: Get redirected to sign in
  	When I try to post an item
  	Then I should see a message asking me to sign in

