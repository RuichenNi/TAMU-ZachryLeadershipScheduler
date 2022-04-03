Feature: As an administrator, I want to see the actions taken by students.
  
Background: Create Term and Cohort
 Given The "New Test Term" terms exist 
 And Registered student and Create term and courses
 And I am logged in as an admin
 And I click "New Term"
 And I select the appropriate term
 And I click button "Activate"
 And I should see the admin terms page
 And I should see "New Test Term"
 And I should see "Apple"
 Then I click "Log out"
 
 Given I am logged in as an admin
 And I follow "Student Actions"
 And I should see "Student Actions"
 And I should not see "created"
 And I should not see "deleted"
 And I click "Log out"
 And I am a registered student
 And I am logged in
 And I click add schedule button
 And I fill in my courses
 And I click save schedule button 
 


@javascript
Scenario: Admin check student created actions
  And I click "Log out"
  And I am logged in as an admin
  And I click "Student Actions" button
  And I should see "created"
  And I should see "schedule"
  And I should not see "deleted"

@javascript
Scenario: Admin check student deleted actions
  And I click "Delete"
  And I confirm popup
  And I click "Log out"
  And I am logged in as an admin
  And I click "Student Actions" button
  And I should see "deleted"
  And I should see "schedule"

@javascript
Scenario: Admin check student edited actions
  And I click the added schedule
  Then I should see added course information
  And I click edit schedule button
  Then I should see added course information for edit
  And I fill in my courses
  And I click save schedule button 
  And I click "Log out"
  And I am logged in as an admin
  And I click "Student Actions" button
  Then I should see "edited"
  And I should see "schedule"
