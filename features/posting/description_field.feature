
Feature: View a description
  As a Looker I want to see the description of an item when viewing its details (if the Lister added a description).

  Background:
  	Given that Jack is is a registered user and posted shoes with the description "awesome kicks"

  @javascript	
  Scenario: Successfully view description
    Given I visit the page for shoes
    Then I should see the description
