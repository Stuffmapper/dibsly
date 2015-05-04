
Feature: List an item on the curb
  As a Lister I want to be able to list items that are on-the-curb/out of my hands items.

  Background:
  	Given that I already have an account 

  @javascript	
  Scenario: Successfully set post status
  	When I login and give stuff and select on the curb
  	Then the post should set the post's status to out of my hands
  	And I should be able to change the out of my hands status after it's posted
