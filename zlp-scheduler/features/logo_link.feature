Feature: Logo Links to Homepage
  
Scenario: Admin is redirected to view_term_admin
  Given I am logged in as an admin
  When I click the logo
  Then I should see the admin terms page
  
Scenario: Student should see schedule page when term is open
  Given I am a registered student
  And the current term is open
  And I am in the active cohort
  And I am logged in
  When I click the logo
  Then I should see the terms page
  
Scenario: Student should see schedule page when term is open and on a different page
  Given I am a registered student
  And the current term is open
  And I am in the active cohort
  And I am logged in
  When I click "Add Schedule"
  And I click the logo
  Then I should see the terms page
  
Scenario: Student should see closed page when term is closed
  Given I am a registered student
  And the current term is not open
  And I am logged in
  When I click the logo
  Then I should see the closed page
  
Scenario: Student should see closed page when in a non-active cohort
  Given I am a registered student
  And the current term is open
  And I am not in the active cohort
  And I am logged in
  When I click the logo
  Then I should see the closed page
  
Scenario: Clicking the logo link before logging in should reload the login page
  Given I visit the index page
  When I click the logo
  Then I should see the login page