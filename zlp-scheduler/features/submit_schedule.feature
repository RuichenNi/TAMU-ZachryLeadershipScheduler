Feature: An student can sumbit her/his schedule
  
Background: log in a a registered student
  Given Registered student and Create term and courses
  And I visit the index page
  And I fill in the login form
  And I should be logged in
  And I should see 0 schedule in the table
  
@javascript
Scenario: Submitting one schedule
  And I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I should see added schedule
  And I click the added schedule
  Then I should see added course information
  
@javascript
Scenario: Add a schedule without filling course number or section number
  And I click add schedule button
  And I fill in courses without select course number or section number randomly
  And I click save schedule button 
  And I should see added schedule
  And I click the added schedule
  Then I should see added course information
  
@javascript
Scenario: Click cancel button after filling courses
  And I click add schedule button
  And I fill in my courses
  And I click cancel button 
  And I should see 0 schedule in the table
  
@javascript
Scenario: Try to add fourth schedule
  #Add 3 schedules
  And I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I should see added schedule
  And I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I should see added schedule
  And I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I should see added schedule
  #Add 4th schedule
  And I click add schedule button
  Then I should see "You may only add 3 schedules."
  
@javascript
Scenario: Submit Schedule without filling schedule name
  And I click add schedule button
  And I fill in my courses without filling schedule name
  And I click save schedule button 
  Then I should see "Schedule must include a name."

@javascript
Scenario: Edit a schedule
  And I click add schedule button
  And I fill in my courses
  And I click save schedule button 
  And I should see added schedule
  And I click the added schedule
  Then I should see added course information
  When I click edit schedule button
  Then I should see added course information for edit
  And I fill in my courses
  And I click save schedule button 
  And I should see added schedule
  And I click the added schedule
  Then I should see added course information
