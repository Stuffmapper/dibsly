Feature: Upload to S3

  As a developer, I want to use S3 for paperclip

  Background:
    Given that I already have an account
    And I am logged in. 

  Scenario: Successfully send a message
    Given that I post a picture of shoes
    Then I should see a picture of shoes
    And the photo source should be on 'AWS'