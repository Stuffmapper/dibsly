
Feature: View Photos of item
  As a Looker who's browsing for free stuff I want at
  minimum to see a photo of each item so I can get a quick idea of what these are.

  Background:
  	Given that there are some items posted near me and I'm geolocated

  @javascript	
  Scenario: Successfully view photo on map
    When I visit the home page
    And click on an item's description on the map
    Then I should see a photo

  @javascript 
  Scenario: Successfully view photo in my stuff
    When I visit the home page
    And click on an item on in stuff
    Then I should see a photo of the stuff

