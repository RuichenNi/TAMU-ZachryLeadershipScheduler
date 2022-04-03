Feature: An Admin can activate the new term
  As an administrator
  so that I can let students add their schedule
  I want to be able to activate the new term.
  
Background: log in as an admin
  Given the following terms exist:
  | name          |
  | Test Term     |
  And I am logged in as an admin
  
Scenario: View new term page
  When I click "New Term"
  Then I should see the new term page
    
Scenario: Cancel activating a term
  When I click "New Term"
  And I click "Cancel"
  Then I should see the admin terms page
  
Scenario: Activate term
  When I click "New Term"
  And I select the appropriate term
  And I click button "Activate"
  Then I should see the admin terms page
  And I should see "Term activated!"
  
Scenario: Load more terms
  When I click "New Term"
  And I click "Load more terms"
  Then I should see the new term page