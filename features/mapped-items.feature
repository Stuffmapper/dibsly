Feature: mapped items
  As a looker 
  I want to be able to see what items are listed near me
  on a map.

  Background:
  	Given that there are some items posted near me
  	And I have allowed my location to be shared

  Scenario: Successfully write articles
    When I visit the home page
    Then I should see a map 
    And I should see some items on the map

