Feature: As an administrator, I want to see a warning when a student makes changes on their schedule after I selected a class time
  

Background: Assume all the term and cohort exists and select the meeting time
  Given The "New Test Term" terms exist 
  And Registered student and Create term and courses
  And I am logged in as an admin
  And I click "New Term"
  And I select the appropriate term
  And I click button "Activate"
  And I should see the admin terms page
  And I should see "New Test Term"
  And I should see "Apple"
  When I click "Log out"
  
  Given I am logged in as the student
  When I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I click "Log out"
  
  Given I am logged in as an admin
  When I click "Apple"
  And I click "Run Algorithm"
  And I click "Find Class Time"
  And I click button "Choose"
  Then I should see the view cohort page for Apple
  And I should see time slot selected for Apple
  And I click "Log out"
  
  And I am logged in as the student
  Then I should see time slot selected for Apple

@javascript  
Scenario: View schedule change warning after schedule deletion
  When I click "Delete"
  And I confirm popup
  And I click "Log out"
  And I am logged in as an admin
  And I click "Apple"
  Then I should see "One or more students updated their schedule after you selected a time. Please run the algorithm again"
  And I should not see "Find Class Time"
  
@javascript  
Scenario: View schedule change warning after schedule addition
  And I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I click "Log out"
  And I am logged in as an admin
  And I click "Apple"
  Then I should see "One or more students updated their schedule after you selected a time. Please run the algorithm again"
  And I should not see "Find Class Time"

@javascript
Scenario: A Student with a schedule cannot Reset Password if Admin disabled modification
  When I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I click "Log out"

  Given I am logged in as an admin
  And I click "Apple"
  And I click "Disable Student Modification"
  And I click "Log out"

  Given I am logged in as the student
  And I click "Log out"
  And I click on the forgot password link
  And I fill in the password reset form
  And I should see information "Student cannot reset password after Admin disabled modification"
