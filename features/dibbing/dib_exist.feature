
Feature: Dib Exists
   As a person who wants priority access to an item's listing (granting exclusive messaging with the lister and hides the listing from others) they hit the "Dibs" button to notify the Lister they are on their way.

  Background:
  	Given I'm a registered user and Jack has posted some shoes and Jill is another registered user

  @javascript	
  Scenario: Successfully dib item
    When I log in and visit the map location where the shoes are. 
    Then I should see the shoes in the menu
    When I hit dib
    Then I should not see the shoes in the menu when I visit the map.
    And Jack should have been notified of my dib.

  @javascript 
  Scenario: Unsuccessfully dib item
    When Jill has dibbed Jack's shoes
    When I log in and visit the map location where the shoes are.
    Then I should not see the shoes in the menu 
    When I visit the shoes permalink page
    Then I should not be able to dib the item.

  @javascript 
  Scenario: Unsuccessfully dib item
    Given I'm logged out
    When I visit the shoes permalink page
    Then I should not be able to dib the "shoes"

