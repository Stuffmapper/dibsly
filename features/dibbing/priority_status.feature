
Feature: 30 minute priority status
    As a "Dibber" who clicks the "Dibs" button they are immediately connected with the Lister in in-app chat with a message that prompts them to initiate a conversation with Lister within 30 minutes or they'll lose their priority status.

  Background:
  	Given I'm a registered user and I've dibbed Jack's shoes

  @javascript	
  Scenario: Initiate contact
    Given I've received an email.
    Then is should explain information about dibs
    And if I follow the link in the email
    Then I should be in the in-app chat
    When I respond, the my dib should be valid 30 minutes from now
    And the post should not be visible and not available to dib

   @javascript	
   Scenario: Don't Initiate contact
    Given I've received an email.
    Then is should explain information about dibs
    When I don't respond, the my dib should not be valid 30 minutes from now
    And the post should be visible and available to dib
    
