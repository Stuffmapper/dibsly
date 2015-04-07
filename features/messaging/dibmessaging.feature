
Feature: 
  As a couple of user that go by the usernames Jack and Jill
  We want to have an in app conversation after a Jill has dibbed Jill's stuff.

  Background:
  	Given that "Jill"  has  posted shoes and "Jack" has dibbed them.

  @javascript	
  Scenario: Sucessfully send a message
    When the  "Jill" logs in and visits the inbox
    Then "Jack's dibbed you shoes!" should be visible.
    And "Jill" should be able to respond "It's on the curb at the junction"
    And "Jack" should see the "It's on the curb at the junction" in his inbox