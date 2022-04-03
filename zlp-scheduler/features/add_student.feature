Feature: An admin can add a new student to a existing cohort
  As an administrator
  So that only active administrators have access to the application
  I want to be able to a new student to a existing cohort.
  
Background: log in as an admin
  Given the following terms exist:
  | name            |
  | Test Term       |
  | Extra Test Term |
  | New Test Term   |
  And the active term is "Test Term"
  And I am logged in as an admin
  
Scenario: View the Manage Cohorts page
  When I click "Manage Cohorts"
  Then I should see the manage cohorts page
  
Scenario: Back to Home button
  When I click "Manage Cohorts"
  And I click "Back to Home"
  Then I should see the admin terms page
  
Scenario: Add  Cancel Button
  When I click "Manage Cohorts"
  And I click "Add student"
  And I click "Cancel"
  Then I should see the manage cohorts page

Scenario: Add student
  When I click "Manage Cohorts"
  And I click "Add student"
  And I fill in the add student form
  Then I should see the manage cohorts page
  And I should see "blah@tamu.edu</td>"

Scenario: Add the same student twice will see error
  When I click "Manage Cohorts"
  And I click "Add student"
  And I fill in the add student form
  Then I should see the manage cohorts page
  And I should see "blah@tamu.edu</td>"
  Then I click "Add student"
  And I fill in the add student form
  And I should see "This email address already exists.Please try another email address."
  

  