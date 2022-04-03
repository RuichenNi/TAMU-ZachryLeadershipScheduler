Feature: As an admin, I can choose a time slot for course time
  and view the result I have chosen.
  As a student, I will see the result the admin has chosen. 
  

Background: Assume all the term and cohort exists
  Given the following terms exist:
  | name          |
  | Test Term     |
  And the active term is "Test Term"
  And the following cohorts exist:
  | name                |
  | Test Cohort   |
  And "Test Cohort" is in the current term
  And The student has added his course to schedule
  And I am logged in as an admin

Scenario: View the view result and non-conflict result
  When I click "Test Cohort"
  Then I should see the view cohort page for Test Cohort 
  When I click "Run Algorithm"
  Then I should see the view cohort page for Test Cohort 
  When I click "Find Class Time"
  Then I should see the view result page for Test Cohort
  When I click button "Choose"
  And I go to view cohort page for Test Cohort
  Then I should see the view cohort page for Test Cohort 
  Then I should see time slot selected for Test Cohort 

Scenario: Run Algorithm Twice
  When I click "Test Cohort"
  When I click "Run Algorithm"
  When I click "Find Class Time"
  When I click button "Choose"
  And I go to view cohort page for Test Cohort
  Then I should see the view cohort page for Test Cohort
  Then I should see time slot selected for Test Cohort
  When I click "Run Algorithm"
  Then I should see the view cohort page for Test Cohort

Scenario: View the view result and non-conflict result
  When I click "Test Cohort"
  And I click "Run Algorithm"
  And I click "Find Class Time"
  And I click button "Details"
  Then I should see the view conflicts page for Test Cohort
  And I click button "Back"
  Then I should see the view result page for Test Cohort

Scenario: student view the result
  When I click "Test Cohort"
  And I click "Run Algorithm"
  And I click "Find Class Time"
  And I click button "Choose"
  And I click on the log out link
  And The term is opened and cohort in it
  And I login back as a student
  Then I should see time slot selected for Test Cohort
