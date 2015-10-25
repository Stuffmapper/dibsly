
Feature: Listing management 
	As a Lister who listed an item I realized I made a mistake and want to edit or depublish it in My Stuff so I can correct my listing.

  Background:
  	Given I already have an account and a post

  @javascript	
  Scenario: Successfully add description
    When I log in and go to my stuff 
    Then I should have an edit option
    And I should be able to click edit and change the details


