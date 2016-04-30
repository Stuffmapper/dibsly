
Feature: 
  As a couple of user that go by the usernames Jack and Jill
  We want to have an in app conversation after a Jill has dibbed Jill's stuff.

  Background:
    Given that "Jill" and "Jack" are registered users
  	And that "Jill"  has  posted shoes and "Jack" has dibbed them.

  @javascript	
  Scenario: Sucessfully send a message
    When "Jill" logs in
    Then "Jack dibbed" should be visible in the inbox
    And "Jill" should be able to respond "It's on the curb at the junction" and log out
    When "Jack" logs in
    Then "It's on the curb at the junction" should be visible in the inbox