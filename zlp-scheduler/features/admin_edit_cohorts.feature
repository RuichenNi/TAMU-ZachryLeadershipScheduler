Feature: As an administrator, I want to edit student information in cohort.
  
Background: Create Term and Cohort
 Given The "New Test Term" terms exist 
 And Registered student and Create term and courses 
 #Default 1 student in cohort
 And I am a registered student
 And I am a registered student 
 #Add 1 more students in cohort
 And I am logged in as an admin
 And I click "New Term"
 And I select the appropriate term
 And I click button "Activate"
 And I should see the admin terms page
 And I should see "New Test Term"
 And I should see "Apple"
 Then I click "Manage Cohorts"

Scenario: Edit first name of a student
  Given I click the label "Apple" 
  And I click "Edit"
  And I edit "firstname" in the page
  And I click button "Update"
  And I should see "Student updated!"
  And I click the label "Apple"
  Then I should see "Corgi_Dog"
  
Scenario: Edit last name of a student
  Given I click the label "Apple" 
  And I click "Edit"
  And I edit "lastname" in the page
  And I click button "Update"
  And I should see "Student updated!"
  And I click the label "Apple"
  Then I should see "Corgi_M"
  
Scenario: Edit email of a student to a valid email address
  Given I click the label "Apple" 
  And I click "Edit"
  And I edit "valid-email" in the page
  And I click button "Update"
  And I should see "Student updated!"
  And I click the label "Apple"
  Then I should see "corgi_mocha@tamu.edu"

Scenario: Edit UIN of a student
  Given I click the label "Apple" 
  And I click "Edit"
  And I edit "Uin" in the page
  And I click button "Update"
  And I should see "Student updated!"
  And I click the label "Apple"
  Then I should see "999999999"

@javascript
Scenario: Edit email of a student to an invalid email address
  Given I click the label "Apple" 
  And I click "Edit"
  And I edit "invalid-email" in the page
  And I click button "Update"
  Then I should remain in the same page
  
Scenario: Edit email of a student to an existed email address
  Given I click the label "Apple" 
  And I click "Edit"
  And I edit "existed-email" in the page
  And I click button "Update"
  Then I should remain in the same page

Scenario: Delete student in cohort
  Given I click the label "Apple" 
  And I want to delete specific student
  Then  I see the message "User deleted!" 
  
Scenario: Delete cohort
  Given I should see "Apple"
  And I want to delete specific cohort
  And I should not see "Apple"
  Then I see the message "Cohort deleted!"
  