Feature: display current term of schedules
 
  As a student so that I can see the schedules I've input into the system I want to be able to view the current term.
  Previously implemented, increase testing.


  Scenario: show student's current schedule 
    Given Registered
    And the current term is open
    And I am logged in
    And I should see the terms page
    Then I should see my schedules
  
  
 