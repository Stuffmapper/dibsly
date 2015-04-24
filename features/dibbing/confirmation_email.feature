
Feature: Dibs confirmation email
    As a "Dibber" who clicks the "Dibs" button they receive a confirmation email that prompts them to click a link to the in-app chat to initiate a conversation with Lister within 30 minutes or they'll lose their priority status.

  Background:
  	Given I'm a registered user and I've dibbed Jack's shoes

  @javascript	
  Scenario: Receive a confirmation email
    Given I've received an email.
    Then is should explain information about dibs
    And if I follow the link in the email
    Then I should be in the in-app chat
