Feature: Sign up 

  As a user that to join stuffmapper

  Background:
    Given that I don't already have an account
    And I am on the page

  Scenario: Successfully sign up
    When I click "sign up" 
    And I fill out the Signup form with my "personal details"
    Then press "Sign up"
    Then I should see a "welcome email" and have the "welcome message" sent to my "email"
    And I should 'be' able to log in

  Scenario: Unsucessfully sign up
    When I click "sign up "
    And I fill out the Signup form with "incomplete details"
    Then I should see the "error message"
    And I should 'not be ' able to log in