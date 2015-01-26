Feature: Send a message on an item

  As a user that wants to communicate with someone who posts an item

  Background:
    Given that I already have an account
    And I am logged in. 
    And "Jack" has posted a "picture of shoes" 
    And "picture of shoes" is not an "on the road item"

  Scenario: Successfully send a message
    Given that I am on the " my home page" 
    And I "dib" a "picture of shoes"  nearby
    Then I should see "Send a message to:" "Jack"
    When I type " Are these men's size 4? " and hit "Send"
    Then "Jack" should receive message Subject:  "RE: picture of shoes" Content: "Are these men's size 4?" 
    And I should have message Subject: "picture of shoes" Content: "Are these men's size 4?" in my "account inbox "
