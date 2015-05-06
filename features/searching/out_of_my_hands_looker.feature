
Feature: Out of My Hands Looker
  As a Looker I want to be able to search for and filter on-the-curb/unattended items.

  Background:
  	Given that there are 6 items on the curb and 3 items not on the curb near me.

  @javascript	
  Scenario: Successfully view on the curb items
    When I visit the home page
    Then I should see all the items 
    When I filter for only on the curb items
    Then I should only see the on the curb items

  @javascript 
  Scenario: Successfully view not on the curb items
    When I visit the home page
    And filter for only not on the curb items
    Then I should only see the not on the curb items

