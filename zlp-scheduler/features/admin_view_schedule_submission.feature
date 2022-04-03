Feature: As an administrator, I want to see which students have submitted their schedules.
  
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

@javascript
Scenario: Admin check schedule submission status
  Given I am a registered student
  And I am logged in
  And I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I should see added schedule 
  And I click "Log out"
  And I am logged in as an admin
  And I click "Apple"
  # 1 user submit and 1 user dont submit
  Then I should see Yes and No
