Feature: Update a dib
	As a lister, I want to be able to repost an item after a dibber has flaked out on me. When I manage my stuff, I should be able to hit a button that removes the "dibbed" status of my post.

Background:
	Given I'm a registered user I've posted some shoes that Jack has dibbed and Jill is also a registered user.

@javascript
Scenario: Remove a dib
	When I manage dibs for shoes in My Stuff
	Then I should see "Jack" as the current dibber
	When I remove current dibber and select "missed pickup"
	Then I should not be able to see "Jack" as the current dibber.
	Then Jill should be able to see the item on the map and dib the item.
	And I should be able to see "Jill" as the current dibber.

@javascript
Scenario: Mark as Gone
	When I manage dibs for shoes in My Stuff
	Then I should see "Jack" as the current dibber
	When I mark as gone and select "dibber has picked up"
	And It should not be on the map and Jill should not be able to dib it.
	And the edit button shouldn't be viewable
	And it should be archived
	And the status should in the details
	And the details should still be viewable
