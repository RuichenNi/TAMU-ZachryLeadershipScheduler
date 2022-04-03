Feature: As an administrator, I want to enable or disable student schedule modification
  
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
 
 Scenario: Disable student modification as an admin
  Given I am a registered student
  And I am logged in
  And I click add schedule button
  Then I should see "Save Schedule"
  And I click "Log out"
  And I am logged in as an admin
  And I click "Apple"
  And I should see "Disable Student Modification"
  And I click "Disable Student Modification"
  And I should see "Student Modification Disabled"
  And I click "Log out"
  Given I am a registered student
  And I am logged in
  Then I should see "Schedule modification is currently disabled for your cohort"
  
 Scenario: Enable student modification as an admin
  And I am logged in as an admin
  And I click "Apple"
  And I should see "Disable Student Modification"
  And I click "Disable Student Modification"
  And I should see "Student Modification Disabled"
  And I should see "Enable Student Modification"
  And I click "Enable Student Modification"
  And I should see "Student Modification Enabled"
  And I click "Log out"
  Given I am a registered student
  And I am logged in
  And I should see "Add Schedule"
  And I click "Add Schedule"
  Then I should see "Save Schedule"