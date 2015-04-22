
Feature: Undibs
   As a person who clicks the "Dibs” button and commits, they realize they don't want the stuff anymore so they decommit (unDibs) by clicking a decommit button so they are no longer accountable.

  Background:
  	Given I'm a registered user and I've dibbed Jack's shoes

  @javascript	
  Scenario: Successfully unDib item
    When I log in and visit the map location where the shoes are.
    Then I should not see the shoes in the menu 
    When I go to my stuff and undibs Jack's shoes
    When I visit the map location where the shoes are. 
    Then I should see the shoes in the menu
    And Jack should have been notified of my unDib.
