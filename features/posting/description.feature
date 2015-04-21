
Feature: Add a description 
  As a Lister who just took a photo of the item I want an optional field to enter additional information so I can describe dimensions, size, and anything else important.

  Background:
  	Given that I already have an account 

  @javascript	
  Scenario: Successfully add description
    When I log in and give stuff
    Then I should be able to put  "These are some awesome kicks" in the description field
    Then I should see my post in my stuff with the description "These are some awesome kicks"

