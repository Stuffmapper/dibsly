Feature: Search for nearby items

  As a user that is looking for specific items. I want to be able to search by name for nearby items

  Background:
    Given that I am on the home page 
    And I have "geolocation defaults" activated
    And "Alice" has posted a "desk" nearby
    And "Jack" has posted a "floor lamp" nearby
    And "Smith" has posted "dresser" faraway 


  Scenario: Successfully find  close items
  	When I search for "lamp"
  	Then I should see "floor lamp"
  	When I search for "desk"
  	Then I should see "desk"
  	When I search for "dresser"
  	Then I should not see "dresser"


  Scenario: Unsucessfully find items
  	When I search for "dresser"
  	Then I should not see "dresser"
  	When I search for "lounge chair"
  	Then I should not see "lounge chair"