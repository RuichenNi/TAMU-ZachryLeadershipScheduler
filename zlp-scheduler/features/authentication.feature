Feature: Authentication
  In order to use the website
  As a user
  I should be able to sign up, log in and log out

Scenario: student login success
  Given I am a registered student
  And I visit the index page
  When I fill in the login form
  Then I should be logged in

Scenario: A logged in student sees closed page if he/she is not in the active cohort
  Given I am a registered student
  And the current term is not open
  And I am logged in
  Then I should see the closed page

Scenario: A logged in student sees terms page if he/she is in the active cohort
  Given I am a registered student
  And the current term is open
  And I am in the active cohort
  And I am logged in
  Then I should see the terms page
  
Scenario: A logged in student sees closed term is the term is open but they are in a different cohort
  Given I am a registered student
  And the current term is open
  But I am not in the active cohort
  And I am logged in
  Then I should see the closed page

Scenario: Student login Failed
  Given I am not a registered student
  And I visit the index page
  When I fill in the login form
  Then I should not be logged in

Scenario: Student logout
  Given I am a registered student
  And I am logged in
  When I click on the log out link
  Then I should be redirected to the login page

Scenario: Administrator login success
  Given I am a registered admin
  And I visit the index page
  When I fill in the login form
  Then I should be logged in

Scenario: A logged in administrator sees view term page
  Given I am a registered admin
  And I am logged in
  Then I should see the admin terms page

Scenario: A Administrator Failed
  Given I am not a registered admin
  And I visit the index page
  When I fill in the login form
  Then I should not be logged in

Scenario: Administrator logout
  Given I am a registered admin
  And I am logged in
  When I click on the log out link
  Then I should be redirected to the login page

Scenario: A Student Reset Password Success
  Given I am a registered student
  When I visit the index page
  And I click on the forgot password link
  And I fill in the password reset form
  Then I should see the closed page
  When I am in the active cohort
  And I click on the log out link
  And I visit the index page
  And I click on the forgot password link
  And I fill in the password reset form
  Then I should see the terms page

Scenario: A Unregistered Student Reset Password Failed
  Given I am not a registered student
  And I visit the index page
  When I click on the forgot password link
  And I fill in the password reset form
  Then I should receive no email
  And I should see the password reset error

Scenario Outline: Claim Acoout - possible combinations
  Given the following user exist:
  | uin       | email                  | password | retype | activate |
  | 000000001 | new_account@tamu.edu   | aaaa     | aaaa   | false    |
  | 000000005 | old_account@tamu.edu   | aaaa     | aaaa   | true     |

  And I visit the index page
  And I click "New User?"
  And I enters "<uin>" in "uin" field
  And I enters "<email>" in "email" field
  And I enters "<password>" in "password" field
  And I enters "<retype>" in "password_confirmation" field
  And I click button "Sign up"
  Then I should see information "<information>"

  Examples: 
  | uin       | email                  | password | retype | information                                  |
  | 000000001 |  new_account@tamu.edu  | aaaa     | aaaa   | You have claimed your account                |
  | 000000002 |  new_account@tamu.edu  | aaaa     | aaaa   | Email not registered or UIN not matched      |
  | 000000001 |  wrongaccount@tamu.edu | aaaa     | aaaa   | Email not registered or UIN not matched      |
  | 000000002 |  wrongaccount@tamu.edu | aaaa     | aaaa   | Email not registered or UIN not matched      |
  | 000000001 |  new_account@tamu.edu  | aa       | aa     | Password is too short                        |
  | 000000001 |  new_account@tamu.edu  | aaaa     | bbbb   | Password confirmation doesn't match Password |
  | 000000005 |  old_account@tamu.edu  | aaaa     | aaaa   | Email is already claimed before              |
