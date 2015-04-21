
Feature: Dib Exists
   As a person who wants priority access to an item's listing (granting exclusive messaging with the lister and hides the listing from others) they hit the "Dibs" button to notify the Lister they are on their way.

  Background:
  	Given that I'm a registered user and Jack has posted some shoes.

  @javascript	
  Scenario: Successfully dib item
    When I visit the map location where the shoes are. 
    Then I should see the shoes in the menu
    When I login and hit dib.
    Then I should not see the shoes in the menu when I visit the map.
    And Jack should have be notified of my dib.

  @javascript 
  Scenario: Unsuccessfully dib item
    When Jill has dibbed Jack's shoes
    When I visit the map location where the shoes are. 
    Then I should not see the shoes
    When I visit the shoes permanalink page
    Then I should not be able to dib the item.

