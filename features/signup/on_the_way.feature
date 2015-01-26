
Feature: On the way button

  As a user wants to get an item fast. I want to be able to hit one button to hide the item from other users and let the item poster know I'm coming to get it.

  Background:
    Given that I am logged into my account 
    And am on "my home page"
    And "Jack" has posted a "barbecue" nearby

  Scenario: Successfully get item
  	I should see a "barbeque"
  	When I click the "on my way " button
  	Then "Jack" should get an "on my way message email "
  	Then User "Jill", "Eve" and "Bob" should  "not be" able to see "barbecue"
  	Then I should "be" able to see the "barbecue" in "my stuff"


  Scenario: Unsucessfully get item
  	I should see a "barbecue"
  	When I click the "on my way " button
  	And I don't pick it up or contact "Jack" in "30" minutes
  	Then "Jack" reposts "barbecue" 
  	And I get a "sorry message"
  	Then I should "not be" able to see the "barbecue" in "my stuff"
  	Then User "Jill", "Eve" and "Bob" should  "be" able to see "barbecue"



